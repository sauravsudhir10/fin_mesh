# fin_mesh
Data Mesh on AWS Lake Formation.

Here's how the architecture breaks down across the key layers:

![Architecture](resources\aws_lake_formation_data_mesh.svg)

**Central governance plane** sits at the top. AWS Lake Formation acts as the policy engine — it owns the permissions model for all S3 locations and Glue catalog databases. AWS Resource Access Manager (RAM) handles cross-account sharing of catalog resources, and IAM/SCPs provide the identity boundary that Lake Formation builds on top of.

**Domain producer accounts** each own their data end-to-end. In the JP Morgan model this means each business line (e.g., trading, risk, retail) is a separate AWS account with its own S3 buckets, Glue ETL pipelines, and an exposed *data product* — a curated, versioned, SLA-backed dataset that other domains consume. The domain team registers their S3 location with Lake Formation and grants access to specific catalogs and columns.

**Glue Data Catalog** is the shared metadata plane. Each producer registers tables into it, and Lake Formation enforces column- and row-level permissions on top of those tables at query time. With RAM sharing, the central catalog entries are visible across accounts without copying data.

**Consumer plane** queries data through Athena, Redshift Spectrum, or EMR — never touching S3 directly. Lake Formation intercepts every query, evaluates LF-Tag-based or column-level grants, and either permits or denies access. This is where the JP Morgan design diverges from classic lake architecture: consumers have no IAM S3 permissions at all; everything flows through Lake Formation.

**LF-Tags** are the key to scale. Instead of granting permissions per table per team (which explodes combinatorially at enterprise scale), you assign attribute tags like `sensitivity=PII`, `domain=trading`, `classification=internal` to databases and columns, then write tag-based permission policies. A new analyst getting access to all `sensitivity=public, domain=retail` data requires one policy change, not dozens.


## Step-by-step project plan 

Here's your single-account build plan, broken into 5 phases you can work through progressively.Here's what each phase teaches you and roughly how long each takes:

![Plan](resources\single_account_data_mesh_plan.svg)

**Phase 1 — Foundation (1–2 hours).** This is the trickiest setup step. You'll create a Lake Formation admin role, set up the LF service-linked role, and — critically — register your S3 bucket location with Lake Formation. Until a location is registered, LF has no authority over it. You'll also switch the account's default permissions from IAM-only to Lake Formation mode, which is the setting that makes LF the gatekeeper.

**Phase 2 — Data domains (1–2 hours).** You'll create two mock domain databases in Glue — say `domain_trading` and `domain_retail` — upload some sample Parquet files to S3, and run Glue crawlers to build the table metadata. This simulates two business domains each owning their data.

**Phase 3 — Access control (2–3 hours).** This is the core of the project. You'll define LF-Tags like `sensitivity=PII`, `domain=trading`, `classification=internal`, tag your databases and columns with them, and then write tag-based permission policies. You'll also apply column-level security so a specific column (e.g., `customer_ssn`) returns `****` for unauthorized roles.

**Phase 4 — Query and validate (1–2 hours).** Create an Athena workgroup, assume an analyst IAM role that has no direct S3 access, and run queries. The key validation: the analyst can query `domain=retail, sensitivity=public` tables but gets a permission denied on `sensitivity=PII` columns — without any S3 bucket policy change. Everything goes through Lake Formation.

**Phase 5 — Data product (2–3 hours).** Write a Glue ETL job that reads from your raw S3 zone, applies a transformation (join, aggregate, or filter), and writes a versioned Parquet output to a curated prefix. Register that curated table back into Glue catalog and grant it to consumers. This closes the loop — you've now built a full producer → data product → consumer pipeline.

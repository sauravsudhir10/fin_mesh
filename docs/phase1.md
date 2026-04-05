# FinMesh — Phase 1 Checklist
## IAM + Lake Formation Setup

---

### Step 1 — Create LF admin IAM role

- [✅] Create `finmesh-lf-admin-trust.json` with LakeFormation + root trust principals
- [✅] Run `aws iam create-role --role-name finmesh-lf-admin`
- [✅] Attach `AWSLakeFormationDataAdmin` managed policy
- [✅] Attach `AWSGlueConsoleFullAccess` managed policy

---

### Step 2 — Create S3 bucket + register location

- [ ] Create bucket `finmesh-datalake-{accountid}` in `ap-south-1`
- [ ] Create S3 prefixes: `raw/`, `curated/`, `domain-trading/`, `domain-retail/`
- [ ] Create `finmesh-lf-service-role` with LakeFormation trust policy
- [ ] Attach `AmazonS3FullAccess` to `finmesh-lf-service-role`
- [ ] Run `aws lakeformation register-resource` for the bucket ARN

---

### Step 3 — Enable LF permission mode

- [ ] In LF console → Settings: uncheck "Use only IAM access control for new databases"
- [ ] Uncheck "Use only IAM access control for new tables in new databases"
- [ ] Run `put-data-lake-settings` with empty default permissions arrays

---

### Step 4 — Grant LF data lake admin

- [ ] Run `lakeformation grant-permissions` with ALL on the registered S3 location
- [ ] Confirm `finmesh-lf-admin` appears under LF Administrators in console

---

### Step 5 — Verify setup

- [ ] Run `aws lakeformation list-resources` — bucket appears
- [ ] Run `aws lakeformation get-data-lake-settings` — admin role listed
- [ ] Run `aws s3 ls s3://finmesh-datalake-{accountid}/` — four prefixes visible

---

> **Note:** Step 3 (enabling LF permission mode) is irreversible. Once IAM-only defaults are removed, Lake Formation becomes the sole gatekeeper for all registered locations.
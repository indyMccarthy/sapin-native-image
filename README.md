# sapin-native-image
Sapin-native-image is a personal project that aims to expose a Springboot Helloworld app into a scalable and serverless environment with GraalVM and Spring Native.

## Required Github secrets

The CICD requires some environment variables to interact with GCP and push artifact into Github packages.

- GCP_PROJECT_ID : GCP project ID
- GCP_SVC_ACCNT : GCP service account ID (ends with `.iam.gserviceaccount.com`)
- GCR_JSON_KEY : The json key associate to your GCP service account (You can generate it using GCloud `gcloud iam service-accounts keys create <keyfile_name>.json --iam-account=<service_account.iam.gserviceaccount.com>`
- GHCR_TOKEN : Github Personal Access Token


## GCP project settings

### API to enable

- `compute.googleapis.com`
- `cloudresourcemanager.googleapis.com`
- `container.googleapis.com`
- `servicenetworking.googleapis.com`

I used GCloud to enable those APIs `gcloud services enable <api_name>`

### Service account's permissions

To be able to use and deploy the different resources (load balancer, cloudrun service, GCS bucket) you need to assign the following roles to your service account:

- `roles/compute.admin`
- `roles/iam.serviceAccountUser`
- `roles/resourcemanager.projectIamAdmin`
- `roles/container.admin`
- `roles/storage.admin`
- `roles/storage.objectViewer`
- `roles/run.admin`

I used GCloud to assign those roles to my service account `gcloud projects add-iam-policy-binding <project_id> --member serviceAccount:<service_account> --role <role>` but it is possible to manage it with Terraform too.

__Note: I am not GCP permission expert, some roles might embed unnecessary permissions.__


## Terraform state

Terraform stores its state into a GCS bucket defined in the `terraform.tf` file and created using GSutil `gsutil mb -p <project_id> -c regional -l <region> gs://<bucket_name>/`.
Manageable with Terraform.


## To reach the service

In order to reach the CloudRun service through the load balancer (given that it is HTTP without SSL enabled) you can GET request using this URL format `http://<LB_IP_ADDRESS>/<google_cloud_run_service.default.name>`
For example `http://34.116.77.52:80/hello-world`

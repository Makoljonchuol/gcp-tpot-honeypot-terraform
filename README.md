# T-Pot Honeypot Deployment with Terraform on GCP

## Overview

This project demonstrates a complete, best-practice workflow for deploying the latest open-source T-Pot honeypot (with ELK stack) on Google Cloud Platform using Terraform. The deployment is fully automated, version-controlled, and designed for repeatability, security research, and collaborative development.

### Key Features

- **Infrastructure as Code**: Modular, reusable Terraform configuration files
- **Automated Deployment**: Complete VM provisioning and firewall setup on GCP
- **Unattended Installation**: Startup script for automated T-Pot (with ELK) installation
- **Security-First**: Secure handling of sensitive files with proper `.gitignore` configuration
- **Easy Access**: Terraform outputs provide immediate access to honeypot resources
- **Version Control**: Git integration for change tracking and collaboration

---

## Table of Contents

1. [Project Structure](#project-structure)
2. [Prerequisites](#prerequisites)
3. [Quick Start](#quick-start)
4. [Detailed Setup](#detailed-setup)
5. [Configuration](#configuration)
6. [File Descriptions](#file-descriptions)
7. [Security Considerations](#security-considerations)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)
10. [Contributing](#contributing)
11. [License](#license)

---

## Project Structure

```
gcp-tpot-honeypot-terraform/
├── main.tf                # Main Terraform configuration
├── variables.tf           # Input variable declarations
├── outputs.tf             # Output value definitions
├── install_tpot.sh        # T-Pot installation script
├── terraform.tfvars.      #variables file
├── .gitignore             # Git exclusion rules
├── README.md              # Project documentation
└── docs/                  # Additional documentation (optional)
    ├── architecture.md
    └── security.md
```

---

## Prerequisites

### Required Tools

- **Google Cloud Account**: Active account with billing enabled
- **GCP Project**: Created project with Project ID readily available
- **Google Cloud SDK**: Installed and authenticated (`gcloud auth login`)
- **Terraform**: Version 1.0+ recommended ([Installation Guide](https://terraform.io/downloads))
- **Git**: For version control and repository management

### Required Permissions

Your GCP user account or service account must have the following IAM roles:

- `Compute Engine Admin` (or `Compute Instance Admin`)
- `Compute Security Admin` (for firewall rules)
- `Project Editor` (alternative broad permission)

### System Requirements

- **Local Machine**: Unix-like system (Linux/macOS) or Windows with WSL
- **Network**: Outbound internet access for downloading packages
- **Storage**: At least 1GB free space for Terraform state and temporary files

---

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/gcp-tpot-honeypot-terraform.git
cd gcp-tpot-honeypot-terraform

# 2. Configure your variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your GCP project details

# 3. Initialize and deploy
terraform init
terraform plan
terraform apply

# 4. Access your honeypot
# Use the external IP from Terraform output
# Navigate to: https://<external_ip>:64297
```

---

## Detailed Setup

### Step 1: Repository Setup

```bash
# Clone the repository
git clone https://github.com/<your-username>/gcp-tpot-honeypot-terraform.git
cd gcp-tpot-honeypot-terraform

# Verify project structure
ls -la
```

### Step 2: GCP Authentication

```bash
# Authenticate with Google Cloud
gcloud auth login

# Set your default project
gcloud config set project YOUR_PROJECT_ID

# Verify authentication
gcloud auth list
gcloud config list
```

### Step 3: Configure Variables

Create your `terraform.tfvars` file:

```hcl
# terraform.tfvars
project_id = "your-gcp-project-id"
region     = "us-central1"
zone       = "us-central1-a"

# Optional: Customize instance settings
instance_type = "e2-standard-4"
disk_size     = 100
honeypot_name = "tpot-honeypot"

# Optional: Network settings
allowed_ips = ["0.0.0.0/0"]  # Restrict this for production use
```

### Step 4: Review Configuration Files

Before deployment, review and customize:

- **main.tf**: Core infrastructure definitions
- **variables.tf**: Available configuration options
- **install_tpot.sh**: T-Pot installation script
- **.gitignore**: Ensures sensitive files aren't committed

### Step 5: Deploy Infrastructure

```bash
# Initialize Terraform (downloads providers)
terraform init

# Preview changes
terraform plan

# Apply configuration
terraform apply
# Type 'yes' when prompted
```

### Step 6: Access T-Pot

After successful deployment:

1. Note the external IP from Terraform output
2. Wait 10-15 minutes for T-Pot installation to complete
3. Access the web interface: `https://<external_ip>:64297`
4. Use default credentials (check T-Pot documentation)

---

## Configuration

### Variables Reference

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `project_id` | GCP Project ID | - | Yes |
| `region` | GCP Region | `us-central1` | No |
| `zone` | GCP Zone | `us-central1-a` | No |
| `instance_type` | VM machine type | `e2-standard-4` | No |
| `disk_size` | Boot disk size (GB) | `100` | No |
| `honeypot_name` | Instance name | `tpot-honeypot` | No |
| `allowed_ips` | CIDR blocks for access | `["0.0.0.0/0"]` | No |

### Customization Options

#### Instance Sizing
```hcl
# For minimal testing
instance_type = "e2-medium"
disk_size     = 50

# For production use
instance_type = "e2-standard-8"
disk_size     = 200
```

#### Network Security
```hcl
# Restrict access to specific IPs
allowed_ips = [
  "203.0.113.0/24",    # Your office network
  "198.51.100.0/24"    # Your home network
]
```

---

## File Descriptions

### Core Terraform Files

#### `main.tf`
Main configuration file containing:
- Google Cloud provider configuration
- Compute Engine instance resource
- Firewall rules for T-Pot services
- Startup script integration

#### `variables.tf`
Input variable declarations with:
- Type definitions
- Default values
- Description and validation rules

#### `outputs.tf`
Output definitions providing:
- External IP address
- Instance name
- SSH connection command

### Supporting Files

#### `install_tpot.sh`
Automated installation script that:
- Updates system packages
- Downloads latest T-Pot release
- Configures T-Pot with ELK stack
- Handles service startup

#### `.gitignore`
Excludes sensitive files:
- `*.tfstate*` (Terraform state files)
- `*.tfvars` (Variable files with secrets)
- `.terraform/` (Provider cache)
- Temporary and log files

#### `terraform.tfvars.example`
Template for configuration variables with:
- Example values
- Comments explaining each setting
- Security recommendations

---

## Security Considerations

### Network Security

1. **Firewall Rules**: The deployment creates specific firewall rules for T-Pot services
2. **IP Restrictions**: Consider limiting `allowed_ips` to known safe networks
3. **Default Credentials**: Change T-Pot default passwords immediately after deployment

### Data Protection

1. **State Files**: Never commit `.tfstate` files to version control
2. **Sensitive Variables**: Use environment variables or GCP Secret Manager for sensitive data
3. **Access Logging**: Enable GCP audit logging for security monitoring

### Monitoring

1. **Resource Monitoring**: Use GCP monitoring to track resource usage
2. **Security Alerts**: Set up alerts for unusual activity patterns
3. **Regular Updates**: Keep T-Pot and system packages updated

---

## Best Practices

### Development Workflow

1. **Version Control**: Always commit infrastructure changes
2. **Branch Strategy**: Use feature branches for major changes
3. **Code Reviews**: Review Terraform changes before applying
4. **Testing**: Test changes in a separate environment first

### Terraform Best Practices

1. **State Management**: Use remote state storage for team collaboration
2. **Variable Management**: Use `.tfvars` files for environment-specific values
3. **Module Structure**: Consider breaking large configurations into modules
4. **Documentation**: Comment complex configurations

### Security Best Practices

1. **Least Privilege**: Grant minimum required permissions
2. **Network Segmentation**: Isolate honeypot from production networks
3. **Regular Audits**: Review and audit access patterns
4. **Backup Strategy**: Implement regular backups of important data

---

## Troubleshooting

### Common Issues

#### Authentication Errors
```bash
# Error: Could not load the default credentials
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

#### Permission Denied for Scripts
```bash
# Error: Permission denied: install_tpot.sh
chmod +x install_tpot.sh
```

#### Resource Creation Errors
```bash
# Check quotas and limits
gcloud compute quotas list --filter="metric:INSTANCES"
```

#### T-Pot Not Accessible
1. Verify VM is running: `gcloud compute instances list`
2. Check firewall rules: `gcloud compute firewall-rules list`
3. Confirm startup script completion: Check VM logs in GCP Console

### Debugging Commands

```bash
# Check Terraform state
terraform show

# View current configuration
terraform plan

# Debug provider issues
terraform providers

# Check GCP resources
gcloud compute instances list
gcloud compute firewall-rules list
```

### Getting Help

1. **T-Pot Documentation**: [Official T-Pot GitHub](https://github.com/telekom-security/tpotce)
2. **Terraform Documentation**: [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
3. **GCP Documentation**: [Google Cloud Console](https://cloud.google.com/docs)

---

## Contributing

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Terraform best practices
- Test changes in a separate environment
- Update documentation for new features
- Add comments for complex configurations

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
Author
Makol Johnchuol
LinkedIn: linkedin.com/in/makol-jc
GitHub: github.com/Makoljonchuol
Cybersecurity & AI Engineer Intern
CrossRealms International

This project was developed as part of cybersecurity research and honeypot deployment automation initiatives.
---
## Acknowledgments

- [T-Pot Project](https://github.com/telekom-security/tpotce) by Deutsche Telekom Security
- [Terraform](https://terraform.io) by HashiCorp
- [Google Cloud Platform](https://cloud.google.com) for infrastructure

---

## Support

Support
For issues and questions:

Check the Troubleshooting section
Review existing GitHub Issues
Create a new issue with detailed information about your problem
---
**Last Updated**: July 2025
Project Version: 1.0.0
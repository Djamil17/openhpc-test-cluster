CREATE DATABASE slurm_accounting;
CREATE USER 'slurm'@'localhost' IDENTIFIED BY 'abc123slurmdbd';
GRANT ALL PRIVILEGES ON slurm_accounting.* TO 'slurm'@'localhost';

# CREATE DATABASE slurm_accounting;
# CREATE USER 'slurm'@'ace-dev-ctrl' IDENTIFIED BY 'abc123slurmdbd';
# GRANT ALL PRIVILEGES ON slurm_accounting.* TO 'slurm'@'ace-dev-ctrl';


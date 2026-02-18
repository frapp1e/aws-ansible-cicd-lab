# AWS + Ansible + CI/CD Lab

Proyecto de laboratorio que integra:

- Terraform: infraestructura en AWS (EC2, VPC, Security Groups)
- Ansible: despliegue automático del servidor web
- CI/CD: GitHub Actions para deploy automatizado

**Nota:** Se excluyen binarios de Terraform y archivos de estado.

## Uso
1. Configurar claves SSH y variables de AWS
2. Ejecutar Ansible: `ansible-playbook -i ansible/hosts.ini ansible/playbook.yml`
3. Desplegar infraestructura con Terraform (sin incluir providers binarios)

# Uso del DevContainer Multi-Cloud

Este repositorio incluye un entorno de desarrollo preconfigurado para trabajar con Azure, AWS y Google Cloud usando Dev Containers en VS Code.

## ¿Cómo usarlo?

1. Instala [Visual Studio Code](https://code.visualstudio.com/) y la extensión [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).
2. Clona este repositorio:
   ```bash
   git clone https://github.com/davidop/multi-cloud-templates.git
   cd multi-cloud-templates
   ```
3. Abre la carpeta en VS Code. VS Code detectará el archivo `.devcontainer/devcontainer.json` y te sugerirá "Reabrir en contenedor". Haz clic en esa opción.
4. El entorno instalará automáticamente Azure CLI, Bicep, Terraform, AWS CLI y Google Cloud CLI.
5. Abre una terminal dentro del contenedor y ejecuta los scripts de ejemplo en la carpeta `scripts/`.

## Personalización adicional

- Puedes agregar variables de entorno en `.devcontainer/devcontainer.json` para tus credenciales o configuraciones específicas.
- Modifica el archivo `scripts/deploy-all.sh` para adaptarlo a tus entornos (`dev`, `test`, `prod`).
- Instala extensiones adicionales de VS Code agregándolas en la sección `customizations.vscode.extensions` del devcontainer.

## Ejemplo de uso rápido

```bash
# Despliegue completo multi-cloud
./scripts/deploy-all.sh
```

## Testing automático multi-cloud

Puedes validar tus despliegues en cada proveedor ejecutando los scripts de testing incluidos:

```bash
# Test AKS en Azure
./scripts/test-aks.sh <nombre-grupo-recursos> <nombre-aks>

# Test recursos AWS
./scripts/test-aws.sh

# Test recursos GCP
./scripts/test-gcp.sh
```

Estos scripts comprueban la existencia y estado de los recursos principales desplegados en cada nube. Puedes integrarlos en pipelines o ejecutarlos manualmente tras cada despliegue.

---

¿Dudas? Consulta la documentación en el README o abre un issue.

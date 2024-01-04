## Helm Notes

### What is Helm
Helm is a package manager for Kubernetes, designed to simplify and streamline the deployment and management of applications on Kubernetes clusters.

Helm uses **charts**, which are packages of pre-configured Kubernetes resources. Charts can be simple, containing only a single application, or complex, composed of multiple interconnected components.

## Components of Helm:
**Helm CLI**: The Helm command-line interface is used to interact with Helm, allowing users to search, install, upgrade, and manage charts.

**Charts**: Charts are collections of files that describe Kubernetes resources. They contain templates, default configurations, and metadata necessary to deploy an application on a Kubernetes cluster.

**Chart Repository**: Helm charts can be stored in repositories, either public or private. Helm CLI interacts with these repositories to fetch and install charts.

## Core Concepts:
**Templates**: Charts often contain templated YAML files. These templates allow for parameterization and customization of Kubernetes manifests before deployment.

**Values**: Values are used to customize the templates within charts. They are supplied during installation or upgrade and override default configurations in the chart.

**Release**: A release is a specific instance of a chart deployed on a Kubernetes cluster. Each release has a unique name and can be managed individually.

**Hooks**: Helm supports hooks that enable users to perform operations during different stages of the deployment lifecycle, such as pre-install, post-install, pre-delete, etc.

### Helm Commands
#### Helm Chart Management
```properties
helm create <name>                      # Creates a chart directory along with the common files and directories used in a chart.
helm package <chart-path>               # Packages a chart into a versioned chart archive file.
helm lint <chart>                       # Run tests to examine a chart and identify possible issues:
helm show all <chart>                   # Inspect a chart and list its contents:
helm show values <chart>                # Displays the contents of the values.yaml file
helm pull <chart>                       # Download/pull chart 
helm pull <chart> --untar=true          # If set to true, will untar the chart after downloading it
helm pull <chart> --verify              # Verify the package before using it
helm pull <chart> --version <number>    # Default-latest is used, specify a version constraint for the chart version to use
helm dependency list <chart>            # Display a list of a chart’s dependencies:
``` 
#### Install and Uninstall Apps
```properties
helm install <name> <chart>                           # Install the chart with a name
helm install <name> <chart> --namespace <namespace>   # Install the chart in a specific namespace
helm install <name> <chart> --set key1=val1,key2=val2 # Set values on the command line (can specify multiple or separate values with commas)
helm install <name> <chart> --values <yaml-file/url>  # Install the chart with your specified values
helm install <name> <chart> --dry-run --debug         # Run a test installation to validate chart (p)
helm install <name> <chart> --verify                  # Verify the package before using it 
helm install <name> <chart> --dependency-update       # update dependencies if they are missing before installing the chart
helm uninstall <name>                                 # Uninstall a release
``` 
#### Perform App Upgrade and Rollback
```properties
helm upgrade <release> <chart>                            # Upgrade a release
helm upgrade <release> <chart> --atomic                   # If set, upgrade process rolls back changes made in case of failed upgrade.
helm upgrade <release> <chart> --dependency-update        # update dependencies if they are missing before installing the chart
helm upgrade <release> <chart> --version <version_number> # specify a version constraint for the chart version to use
helm upgrade <release> <chart> --values                   # specify values in a YAML file or a URL (can specify multiple)
helm upgrade <release> <chart> --set key1=val1,key2=val2  # Set values on the command line (can specify multiple or separate valuese)
helm upgrade <release> <chart> --force                    # Force resource updates through a replacement strategy
helm rollback <release> <revision>                        # Roll back a release to a specific revision
helm rollback <release> <revision>  --cleanup-on-fail     # Allow deletion of new resources created in this rollback when rollback fails
``` 
#### List, Add, Remove, and Update Repositories
```properties
helm repo add <repo-name> <url>   # Add a repository from the internet:
helm repo list                    # List added chart repositories
helm repo update                  # Update information of available charts locally from chart repositories
helm repo remove <repo_name>      # Remove one or more chart repositories
helm repo index <DIR>             # Read the current directory and generate an index file based on the charts found.
helm repo index <DIR> --merge     # Merge the generated index with an existing index file
helm search repo <keyword>        # Search repositories for a keyword in charts
helm search hub <keyword>         # Search for charts in the Artifact Hub or your own hub instance
``` 
#### Helm Release monitoring
```properties
helm list                       # Lists all of the releases for a specified namespace, uses current namespace context if namespace not specified
helm list --all                 # Show all releases without any filter applied, can use -a
helm list --all-namespaces      # List releases across all namespaces, we can use -A
helm -l key1=value1,key2=value2 # Selector (label query) to filter on, supports '=', '==', and '!='
helm list --date                # Sort by release date
helm list --deployed            # Show deployed releases. If no other is specified, this will be automatically enabled
helm list --pending             # Show pending releases
helm list --failed              # Show failed releases
helm list --uninstalled         # Show uninstalled releases (if 'helm uninstall --keep-history' was used)
helm list --superseded          # Show superseded releases
helm list -o yaml               # Prints the output in the specified format. Allowed values: table, json, yaml (default table)
helm status <release>           # This command shows the status of a named release.
helm status <release> --revision <number>   # if set, display the status of the named release with revision
helm history <release>          # Historical revisions for a given release.
helm env                        # Env prints out all the environment information in use by Helm.
```
#### Download Release Information
```properties
helm get all <release>      # A human readable collection of information about the notes, hooks, supplied values, and generated manifest file of the given release.
helm get hooks <release>    # This command downloads hooks for a given release. Hooks are formatted in YAML and separated by the YAML '---\n' separator.
helm get manifest <release> # A manifest is a YAML-encoded representation of the Kubernetes resources that were generated from this release's chart(s). If a chart is dependent on other charts, those resources will also be included in the manifest.
helm get notes <release>    # Shows notes provided by the chart of a named release.
helm get values <release>   # Downloads a values file for a given release. use -o to format output
```

### Helm Chart Structure
```
└── basechart
    ├── .helmignore
    ├── Chart.yaml                      # A YAML file containing information about the chart
    ├── LICENSE                         # OPTIONAL: A plain text file containing the license for the chart
    ├── README.md                       # OPTIONAL: A human-readable README file
    ├── charts                          # A directory containing any charts upon which this chart depends.
    ├── templates                       # A directory of templates that, when combined with values, will generate valid Kubernetes manifest files.
    │   ├── NOTES.txt
    │   ├── _helpers.tpl                
    │   ├── deployment.yaml
    │   ├── hpa.yaml
    │   ├── ingress.yaml
    │   ├── service.yaml
    │   ├── serviceaccount.yaml
    │   └── tests                       # Helm tests enable users to verify the correctness and health of a deployed application
    │       └── test-connection.yaml
    └── values.yaml                     # The default configuration values for this chart
```
## Helm Built-in Objects
In Helm charts, built-in objects offer dynamic values you can access within your templates to customize deployments and make your charts more flexible. These objects provide information about the release, the chart itself, and even the environment during templating.
#### Release Object:
Example: Accessing the release name for generating unique resource names:
```
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-service
spec:
  selector:
    app: {{ .Chart.Name }}
  ports:
    - port: 80
      targetPort: 8080
```
#### Values Object:
Example: Using a custom value from values.yaml to configure a deployment:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app-container
        image: my-app-image:{{ .Values.imageTag }}
        ports:
        - containerPort: 8080
```
#### File Object
This object allows accessing the contents of files inside your chart template directory.

Example: Including a configuration file from the chart during deployment:

Let's assume you have two files, app.properties and database.properties, both containing key-value pairs. You want to combine the content of these files into a single ConfigMap.

Directory structure:
```
my-chart/
├── Chart.yaml
├── values.yaml
├── templates/
│   └── configmap.yaml
└── files/
    ├── app.properties
    └── database.properties
```
Here's an example of how the configmap.yaml template file might look:
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-configmap
data:
  app.properties: |-
{{ .Files.Get "app.properties" | indent 4 }}
  database.properties: |-
{{ .Files.Get "database.properties" | indent 4 }}

```
This template creates a ConfigMap named my-configmap with two keys (app.properties and database.properties). It retrieves the content from the respective files in the files directory and indents them by 4 spaces for proper YAML formatting.

The content of app.properties and database.properties should look like key-value pairs:

__app.properties__:
```
key1=value1
key2=value2

```
__database.properties__:
```
db_host=my-db-host
db_user=my-db-user

```
When you install or upgrade the Helm chart, Helm will read the content from __app.properties__ and __database.properties__ files and populate the data section of the ConfigMap accordingly.


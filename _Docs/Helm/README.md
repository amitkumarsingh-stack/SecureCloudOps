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
    │   ├── _helpers.tpl                # _helpers.tpl contains the re-usable named templates required for Helm Charts
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

## Template Function List
## default
The ```default``` function in Helm is used to set a default value for a variable or expression within a template. It comes in handy when you want to ensure a value is always present, even if it's not explicitly provided in the values file or context.

Example
```
# values.yaml (optional)
favorite:
  drink: coffee
```
```
# template.yaml
drink: {{ .Values.favorite.drink | default "tea" }}
```
Output:

If ```values.yaml``` is provided and ```favorite.drink``` is set to "coffee", the output will be "coffee".
If ```values.yaml``` is not provided or ```favorite.drink``` is not set, the output will be "tea" (the default value).

## required
The required function enforces the presence of a specific value in Helm templates. It ensures that a critical value is always provided by the user, preventing potential errors or misconfigurations.
Syntax:
```
{{ required ERROR_MESSAGE GIVEN_VALUE }}
```
Explanation:

* ```ERROR_MESSAGE```: This is a custom error message that will be displayed if ```GIVEN_VALUE``` is empty or not defined.
* ```GIVEN_VALUE```: This is the value that will be checked for emptiness.
Example
```
# template.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ required "A valid name is required!" .Values.name }}
  # ... other fields
```
Behavior:

* If ```.Values.name``` is set and not empty, the template renders normally, and the deployment's name will be set to the provided value.
* If ```.Values.name``` is empty or not defined, the template rendering fails with the error message **"A valid name is required!"**, preventing incorrect deployment configuration.

## toYaml
* Converts a value of any supported type (list, slice, array, dictionary, or object) into an indented YAML string.
* Useful for embedding YAML blocks within templates, especially when those blocks come from variables or other dynamic sources.

Example
```
# values.yaml
annotations:
  kubernetes.io/ingress.class: nginx
  traefik.ingress.kubernetes.io/rate-limit: |
    extractorfunc: client.ip
    rateset:
      api-rateset:
        period: 60s
        average: 10
        burst: 20
```
```
# ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    # Embed annotations from values.yaml as YAML
    {{- toYaml .Values.annotations | nindent 4 }}
```


Here's a definition and example of the toYaml function in Helm:

Definition:

Converts a value of any supported type (list, slice, array, dictionary, or object) into an indented YAML string.
Useful for embedding YAML blocks within templates, especially when those blocks come from variables or other dynamic sources.
It's equivalent to Go's yaml.Marshal function.
Example:

YAML
# values.yaml
annotations:
  kubernetes.io/ingress.class: nginx
  traefik.ingress.kubernetes.io/rate-limit: |
    extractorfunc: client.ip
    rateset:
      api-rateset:
        period: 60s
        average: 10
        burst: 20
Use code with caution. Learn more
YAML
# ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    # Embed annotations from values.yaml as YAML
    {{- toYaml .Values.annotations | nindent 4 }}

Explanation:

* The annotations key in ```values.yaml`` holds a YAML block.
* In ```ingress.yaml```, ```toYaml .Values.annotations``` converts that block into a YAML string.
* ```nindent 4``` indents the YAML string by 4 spaces, ensuring correct formatting within the annotations section.

#### toJSON
* Converts a value of any supported type (list, slice, array, dictionary, or object) into a JSON string.
* Employed when you need to create JSON-formatted data within your Helm templates.
```
# values.yaml
configData:
  server: nginx
  version: 1.21.6
  ports:
    - 80
    - 443
```
```
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-configmap
data:
  appsettings.json: |
    {{- toJSON .Values.configData | nindent 4 }}
```
Explanation:

* The configData in ```values.yaml``` holds configuration values.
* In ```configmap.yaml```, ```toJSON .Values.configData``` converts those values into a JSON string.
* ```nindent 4``` indents the JSON string by 4 spaces for aesthetic formatting.

## ifElse with EQ
ifElse with EQ lets you create "rules" within the template:
* You can check if a value matches a specific condition (like "is the environment 'production'?").
* Based on the result (true or false), you can fill in different parts of the template accordingly.

Example:
* If the environment is "production", you might set higher resource limits for your app to handle more traffic.
* If it's not "production", you might use lower limits to save resources.
```
{{- if eq .Values.environment "prod" }}
replicaCount: 3
{{- else if eq .Values.environment "qa" }}
replicaCount: 2
{{- else }}
replicaCount: 1
{{- end }}
```
This snippet assumes that you have a value called environment defined in your values.yaml file. Depending on the value of environment, it will set the replicaCount accordingly: 3 for "prod", 2 for "qa", and 1 as a default for any other environment.

## ifElse with Boolean check and AND function
Let's say you want to set a resource to use a specific image only if both a certain boolean flag (useSpecificImage) is true and the environment is "production".
```
{{- if and .Values.useSpecificImage (eq .Values.environment "production") }}
  image:
    repository: my-specific-image
    tag: latest
{{- else }}
  image:
    repository: default-image
    tag: latest
{{- end }}
```
This example checks two conditions using and:

* ```useSpecificImage`` should be ```true```.
* The ```environment``` should be ```"production"```.
If both conditions are **true**, it sets the image repository to **my-specific-image:latest**. Otherwise, it defaults to **default-image:latest**.

## Helm ifElse with OR Function
Example
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: {{- if or (eq .Values.environment "prod") (eq .Values.environment "qa") .Values.featureXEnabled }}
    5  # More replicas for production, QA, or if feature X is enabled
  {{- else }}
    3  # Default replica count
  {{- end }}
```
Explanation:

1. ```{{- if or (eq .Values.environment "prod") (eq .Values.environment "qa") .Values.featureXEnabled }}```:

* Starts an if block with three conditions using the or function:
    * ```(eq .Values.environment "prod")```: Checks if the environment is "production".
    * ```(eq .Values.environment "qa")```: Checks if the environment is "qa".
    * ```.Values.featureXEnabled```: Checks if the featureXEnabled value is true.
2. Replica count:
* If any of the three conditions are true, the replica count is set to 5.
* Otherwise, it defaults to 3.

## Helm ifElse with NOT Function
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: {{- if not (or (eq .Values.environment "prod") .Values.featureXEnabled) }}
    5  # More replicas if NOT in production and feature X is NOT enabled
  {{- else }}
    3  # Default replica count
  {{- end }}
```
Explanation:

1. ```{{- if not (or (eq .Values.environment "prod") .Values.featureXEnabled) }}```:

* Starts an if block with a negated condition using the not function:
  * ```(or (eq .Values.environment "prod") .Values.featureXEnabled)```: An inner condition checking if either the environment is "production" or feature X is enabled.
  * The not function reverses the result, so the if block executes only if both of those conditions are false.

2. Replica count:

* If the environment is not "production" and feature X is also not enabled, the replica count is set to 5.
* Otherwise, it defaults to 3.

## Access Single object using WITH from a Dictionary
Suppose you have a dictionary of databases in your values.yaml:
```
# values.yaml
databases:
  mysql:
    host: "mysql.example.com"
    port: 3306
    username: "mysql_admin"
    password: "mysql_password"
  postgres:
    host: "postgres.example.com"
    port: 5432
    username: "postgres_admin"
    password: "postgres_password"
```
And you want to access the postgres database details in your Helm template:
```
{{- with .Values.databases.postgres }}
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
data:
  host: {{ .host }}
  port: {{ .port }}
  username: {{ .username }}
  password: {{ .password | b64enc }}
{{- end }}
```
Here, .Values.databases.postgres specifies that you're accessing the postgres database object within the databases dictionary. Within the with block, you directly access the properties (host, port, username, password) of the postgres database without explicitly mentioning the path to the entire dictionary.

## Helm Range with List
Let's assume you have a list of namespaces defined in your ```values.yaml``` file:
```
# values.yaml
namespaces:
  - namespace1
  - namespace2
  - namespace3
```
Now, you can use the range function in your Helm templates to create resources for each namespace:
```
{{- range .Values.namespaces }}
apiVersion: v1
kind: Namespace
metadata:
  name: {{ . }}
---
apiVersion: v1
kind: Service
metadata:
  name: my-service-{{ . }}
  namespace: {{ . }}
spec:
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
---
# Any other resources you want to create for each namespace can go here
{{- end }}
```
In this example:
* ```range .Values.namespaces``` iterates through each item in the namespaces list.
* ```{{ . }}``` represents the current namespace in the iteration.
* ```---:```: The triple dashes ```(---)``` between each iteration create separate YAML documents, ensuring each namespace is defined as an independent object.
* For each namespace, it creates a Kubernetes Namespace resource with the name taken from the list.
* Additionally, it creates a Service resource named ```my-service-{{ . }}``` within each namespace, with a selector targeting an app named ```my-app``` on port **8080**.

## Helm Range with Dictionary
if you have a dictionary structure in your ```values.yaml``` file and want to create ConfigMaps in Kubernetes based on that dictionary using Helm's ```range``` function, you can do something like this:
1. Let's assume you have the following structure in your ```values.yaml```:
```
configMapData:
  key1: value1
  key2: value2
  key3: value3
```
2. Create the template:
* In your template file ```(e.g., templates/configmap.yaml)```, use the ```range``` function to iterate over the dictionary:
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-configmap
data:
  {{- range $key, $value := .Values.configMapData }}
  {{ $key }}: {{ $value | quote }}
  {{- end }}
```
Explanation:

* ```range $key, $value := .Values.configMapData``` iterates over each key-value pair in the dictionary.
* ```$key``` holds the current key in each iteration.
* ```$value``` holds the current value.
* ```{{ $value | quote }}``` quotes the value to ensure proper YAML formatting.
3. Render the template:
* Use the ```helm template``` command to render the template with ```values.yaml```:
```
helm template my-chart ./values.yaml
```
4. Inspect the Output
* The output will contain a ConfigMap with the specified keys and values from values.yaml:
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-configmap
data:
  key1: value1
  key2: value2
  key3: value3
```
Key points:
* The ```range``` function can iterate over dictionaries as well as lists.
* It creates a temporary context for each key-value pair, allowing access to both the key and value.
* This approach dynamically populates a ConfigMap with values from a dictionary.

## Demo - Helm Built-In Object
1. Lets generate a Chart
```
$ helm create helmbasics
```
The example helm chart and manifests used in this Helm Chart Tutorial are hosted on the Helm Chart Github repo. You can clone it and use it to follow along with the guide.
```
git clone https://github.com/techiescamp/helm-tutorial.git
```
If you check the created chart, it will have the following files and directories.
```
helmbasics
│   ├── Chart.yaml
│   ├── charts
│   ├── templates
│   │   ├── NOTES.txt
│   │   ├── _helpers.tpl
│   │   ├── deployment.yaml
│   │   ├── hpa.yaml
│   │   ├── ingress.yaml
│   │   ├── service.yaml
│   │   ├── serviceaccount.yaml
│   │   └── tests
│   │       └── test-connection.yaml
│   └── values.yaml
```
```
cd helmbasics
```
#### Chart.yaml
As mentioned above, we put the details of our chart in Chart.yaml file. Replace the default contents of chart.yaml with the following.
```
apiVersion: v2
name: helmbasics
description: My First Helm Chart
type: application
version: 0.1.0
appVersion: "1.0.0"
maintainers:
- email: xxx@xxx.com
  name: devopscube
```
1. **apiVersion***: This denotes the chart API version. v2 is for Helm 3 and v1 is for previous versions.
2. **name**: Denotes the name of the chart.
3. **description**: Denotes the description of the helm chart.
4. **Type**: The chart type can be either ‘application’ or ‘library’. Application charts are what you deploy on Kubernetes. Library charts are re-usable charts that can be used with other charts. A similar concept of libraries in programming.
5. **Version**: This denotes the chart version. 
6. **appVersion**: This denotes the version number of our application (Nginx). 
7. **maintainers**: Information about the owner of the chart.

#### Templates
There are multiple files in templates directory created by Helm. In our case, we will work on simple Kubernetes Nginx deployment.

Let’s remove all default files from the template directory.
```
rm -rf templates/*
```
We will add our Nginx YAML files and change them to the template for better understanding.

Create a **deployment.yaml** file and copy the following contents.
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: "nginx:1.16.0"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
```
If you see the above YAML file, the values are static. The idea of a helm chart is to template the YAML files so that we can reuse them in multiple environments by dynamically assigning values to them.

To template a value, all you need to do is add the **object parameter** inside curly braces as shown below. It is called a template directive and the syntax is specific to the Go templating
```
{{ .Object.Parameter }}
```
First Let’s understand what is an Object. Following are the three Objects we are going to use in this example.
1. **Release**: Every helm chart will be deployed with a release name. If you want to use the release name or access release-related dynamic values inside the template, you can use the release object.
2. **Chart**: If you want to use any values you mentioned in the chart.yaml, you can use the chart object.
3. **Values**: All parameters inside values.yaml file can be accessed using the Values object.
   
The following image shows how the built-in objects are getting substituted inside a template.
![Alt text](/_Docs/Helm/image/Image1.png)

First, you need to figure out what values could change or what you want to templatize. I am choosing name, replicas, container name, image, and imagePullPolicy which I have highlighted in the YAML file in bold.
1. **name**: ```name: {{ .Release.Name }}-nginx``` : We need to change the deployment name every time as Helm does not allow us to install releases with the same name. So we will templatize the name of the deployment with the release name and interpolate -nginx along with it. Now if we create a release using the name **frontend**, the deployment name will be frontend-nginx. This way, we will have guaranteed unique names.
2. **container name**: ```{{ .Chart.Name }}```: For the container name, we will use the Chart object and use the chart name from the chart.yaml as the container name.
3. **Replicas**: ```{{ .Values.replicaCount }}``` We will access the replica value from the values.yaml file.
4. **image**: ```"{{ .Values.image.repository }}:{{ .Values.image.tag }}"``` Here we are using multiple template directives in a single line and accessing the repository and tag information under the image key from the Values file.

Similarly, you can templatize the required values in the YAML file.

Here is our final ```deployment.yaml``` file after applying the templates. 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-nginx
  labels:
    app: nginx
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
```
Create ```service.yaml``` file and copy the following contents.
```
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-service
spec:
  selector:
    app.kubernetes.io/instance: {{ .Release.Name }}
  type: {{ .Values.service.type }}
  ports:
    - protocol: {{ .Values.service.protocol | default "TCP" }}
      port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
```
In the **protocol** template directive, you can see a pipe ( | ) . It is used to define the default value of the protocol as TCP. So that means we won’t define the protocol value in ```values.yaml``` file or if it is empty, it will take TCP as a value for protocol.

Create a **configmap.yaml** and add the following contents to it. Here we are replacing the default Nginx **index.html** page with a custom HTML page. Also, we added a template directive to replace the environment name in HTML.
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-index-html-configmap
  namespace: default
data:
  index.html: |
    <html>
    <h1>Welcome</h1>
    </br>
    <h1>Hi! I got deployed in {{ .Values.env.name }} Environment using Helm Chart </h1>
    </html
```
#### values.yaml
The values.yaml file contains all the values that need to be substituted in the template directives we used in the templates.

Now, replace the default **values.yaml** content with the following.
```
replicaCount: 2

image:
  repository: nginx
  tag: "1.16.0"
  pullPolicy: IfNotPresent

service:
  name: nginx-service
  type: ClusterIP
  port: 80
  targetPort: 9000

env:
  name: dev
```
Now we have the Nginx helm chart ready and the final helm chart structure looks like the following.
```
helmbasics
├── Chart.yaml
├── charts
├── templates
│   ├── configmap.yaml
│   ├── deployment.yaml
│   └── service.yaml
└── values.yaml
```
#### Validate the Helm Chart
```
helm lint .
```
If there is no error or issue, it will show this result
```
==> Linting ./nginx
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```
To validate if the values are getting substituted in the templates, you can render the templated YAML files with the values using the following command.
```
helm template .
```

We can also use --dry-run command to check. This will pretend to install the chart to the cluster and if there is some issue it will show the error.
```
helm install --dry-run my-release nginx-chart
```

#### Deploy the Helm Chart
When you deploy the chart, Helm will read the chart and configuration values from the values.yaml file and generate the manifest files. Then it will send these files to the Kubernetes API server, and Kubernetes will create the requested resources in the cluster.
```
helm install frontend nginx-chart
```
You will see the output as shown below.
```
NAME: frontend
LAST DEPLOYED: Tue Dec 13 10:15:56 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

## Reference "Helm Master Class"
[Helm Master Class](https://github.com/stacksimplify/helm-masterclass)


## ArgoCD
### What is GitOps?
GitOps is a methodology for managing and deploying applications in Kubernetes using Git as the single source of truth for the desired state of the system. ArgoCD is one of the popular tools that implements the GitOps workflow in Kubernetes.

### Features
Here's how GitOps works with ArgoCD:

1. **Declarative Configuration**: With GitOps, the desired state of the applications, including configurations, manifests, and other resources, is stored in a Git repository. This repository serves as the source of truth.

2. **Continuous Synchronization**: ArgoCD continuously monitors the Git repository for changes. When changes are detected (such as updates to configuration files or manifests), ArgoCD automatically reconciles the actual cluster state with the desired state defined in the repository.

3. **Automated Deployment**: Any changes made to the Git repository trigger an automated deployment process by ArgoCD. It ensures that the applications running in the Kubernetes cluster match the desired state described in the Git repository.

4. **Observability and Rollbacks**: ArgoCD provides visibility into the state of applications deployed in the cluster through its user interface. Additionally, it supports rollback capabilities, allowing users to revert to a previously known good state in case of issues or errors.

5. **Multi-Environment Support**: GitOps with ArgoCD enables managing multiple environments (e.g., development, staging, production) using Git branches or directories within the repository, allowing for consistent deployments across different environments.

Overall, GitOps using ArgoCD streamlines and automates the deployment and management of Kubernetes applications by leveraging Git as the central control plane, enabling teams to maintain a consistent and auditable deployment process while promoting collaboration through version control.

## Architecture Overview
![Alt text](/_Docs/ArgoCD/images/ArgoCD_Architecture.png)

## Components
### API server
The API server is a gRPC/REST server which exposes the API consumed by the Web UI, CLI, and CI/CD systems. It has the following responsibilities:

* application management and status reporting
* invoking of application operations (e.g. sync, rollback, user-defined actions)
* repository and cluster credential management (stored as K8s secrets)
* authentication and auth delegation to external identity providers
* RBAC enforcement
* listener/forwarder for Git webhook events

### Repository Server
The repository server is an internal service which maintains a local cache of the Git repository holding the application manifests. It is responsible for generating and returning the Kubernetes manifests when provided the following inputs:

* repository URL
* revision (commit, tag, branch)
* application path
* template specific settings: parameters, helm values.yaml

### Application Controller
The application controller is a Kubernetes controller which continuously monitors running applications and compares the current, live state against the desired target state (as specified in the repo). It detects OutOfSync application state and optionally takes corrective action. It is responsible for invoking any user-defined hooks for lifecycle events (PreSync, Sync, PostSync)

## Installation

### Prerequisites

- Azure Kubernetes cluster (minikube, AKS, EKS, GKE, etc.)
- `kubectl` CLI installed and configured to connect to your Kubernetes cluster.

### Install ArgoCD using kubectl

1. Apply ArgoCD manifests to your cluster:

    ```bash
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/<VERSION>/manifests/install.yaml
    ```

    Replace `<VERSION>` with the desired ArgoCD version.

2. Access the ArgoCD web UI using port forwarding:

By default, the Argo CD API server is not exposed with an external IP. To access the API server, choose one of the following techniques to expose the Argo CD API server:

Change the argocd-server service type to ```LoadBalancer```:
```
# kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
Now you will be able to see that the argocd-server service type has been changed to a LoadBalancer type. This means that it now has a public Azure load balancer attached to it with an external IP.

```
# kubectl get svc -n argocd
```
3. Login Using The CLI
The initial password for the admin account is auto-generated and stored as clear text in the field ```password``` in a secret named ```argocd-initial-admin-secret``` in your Argo CD installation namespace. You can simply retrieve this password using ```kubectl```:
```
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
Using the username admin and the password from above, login to Argo CD’s IP or hostname:

That’s it for now! we have Argo CD deployed on your AKS cluster. In coming posts will see how to deploy a app using argoCD and also how to integrate with GIT repository.

## Usage

### Adding Applications

1. Log in to the ArgoCD UI.
2. Click on `New App` and provide the Git repository URL and other application details.
3. Configure the sync policy, including the sync strategy, automated sync frequency, and destination cluster details.
4. ArgoCD will start syncing the application state as per the defined configuration in the Git repository.

### Monitoring Applications

- View the deployed applications and their statuses in the ArgoCD UI.
- Check sync status, health, and history of applications.

### Continuous Deployment

- Make changes to the application manifests in the Git repository.
- ArgoCD will automatically detect changes and trigger the sync process to apply the updates to the Kubernetes cluster.

## Demo
In order for us to create an application to demonstrate how Argo CD works, we are going to use an example repository containing a guestbook application. If you would like to check it out or follow along, it is available at https://github.com/argoproj/argocd-example-apps.git.

#### Creating Apps Via UI

* Open a browser and login using the admin credentials we set up earlier. 
* After logging in, click the “+ New App” button as shown below:
![Alt text](/_Docs/ArgoCD/images/ArgoCD1.png)
* Give your app the name ```guestbook```, use the project ```default```, and leave the sync policy as ```Manual```
* Connect the https://github.com/argoproj/argocd-example-apps.git repo to Argo CD by setting repository URL to the GitHub repo URL, leave revision as ```HEAD```, and set the path to ```guestbook```:
![Alt text](/_Docs/ArgoCD/images/ArgoCD2.png)
* For Destination, set cluster to ```in-cluster``` and namespace to ```default```:
![Alt text](/_Docs/ArgoCD/images/ArgoCD3.png)

#### Sync (Deploy) The Application

Once the guestbook application is created, you can now view its status:
![Alt text](/_Docs/ArgoCD/images/ArgoCD4.png)
As you can see, the application status is ```OutOfSync! OutOfSync``` means the git state is different from the cluster state. You can see this information in multiple ways while in the UI. When the state is not in sync, you can usually tell as it is in a helpful yellow color. You can also filter by status on the left side of the dashboard. I highly recommend poking around the dashboard to see which configuration works for you!

That said, the application status is initially in ```OutOfSync``` state since the application has yet to be deployed. Also, no Kubernetes resources have been created. To sync (deploy) the application, we’ll use the “Sync” button.

This will bring up a second set of options. Select “Synchronize”.
![Alt text](/_Docs/ArgoCD/images/ArgoCD5.png)

Synchronizing is how we deploy the application. When we “Sync” or “Synchronize”, it means we are updating the cluster state to match the Git state. This is one of the most important tenets of GitOps.

Once things are complete and you return to the dashboard, you will see the guestbook app is now running. Select the app and see what information you can find!
![Alt text](/_Docs/ArgoCD/images/ArgoCD6.png)
![Alt text](/_Docs/ArgoCD/images/ArgoCD7.png)
If you click on the application name, you will see a hierarchical view of all the Kubernetes resources that take part in the application. You will also see additional details related to the health and synchronization status.

## Modifying and redeploying the Application
Here is where I feel Argo CD really shines. Now that we have a healthy system, let’s initiate a change. Let’s scale the deployment by modifying the replicas in the ```deployment.yaml``` file.

In the ```deployment.yaml``` file, increase the number of replicas from 1 to 2. Since we are following GitOps, we want our modification to be declarative. So, we are going to commit and submit this change via Git. This will show things OutOfSync as well as identify configuration drift.
If you go back to the UI, you should now see that we are now once again OutOfSync!
![Alt text](/_Docs/ArgoCD/images/ArgoCD8.png)

I sincerely love this feature, because not only does Argo CD let us know the application is no longer in sync, it also gives you a nice “App Diff” view to give more detail about what was changed! Click on the application name again, and you will see this option at the top of the page.

![Alt text](/_Docs/ArgoCD/images/ArgoCD9.png)
Now, the default “Diff” view can potentially contain an enormous amount of information, so I like to select the “Compact Diff” option in order to immediately see any changes. As you can see, we increased our replicas from 1 > 2.

![Alt text](/_Docs/ArgoCD/images/ArgoCD10.png)

Follow the same steps to deploy an application by using the “Sync” button, and we should be back to a healthy app.

![Alt text](/_Docs/ArgoCD/images/ArgoCD11.png)

### Conclusion
As you can see, adopting GitOps is beneficial in many ways! Among other things, you gain faster and more frequent deployments, the ability to avoid configuration drift, and easier error handling. This is shown especially when coupled with Argo CD as it can help leverage your deployment process by performing commits automatically and can also execute rollbacks if there are any issues.

Argo CD is great by itself, but it is even better when connected to other Argo projects such as Argo Workflows, Rollouts, or Events. Combined with any of these, you can elevate your continuous deployment process.

## Contributing

We welcome contributions! Please feel free to raise issues or submit pull requests for any enhancements or bug fixes.

## Resources

- [ArgoCD Documentation](https://argoproj.github.io/argo-cd/)
- [GitHub Repository](https://github.com/argoproj/argo-cd)

## License

This project is licensed under the [Apache License 2.0](LICENSE).


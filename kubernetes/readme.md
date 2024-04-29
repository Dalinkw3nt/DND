# DND Interview Kubernetes

We have a cluster running Kubernetes 1.26 on EKS. It is running the `ingress-nginx` ingress controller to expose the underlying applications via an AWS NLB. 

DNS is pointing `example.dyedurham.dev` to this NLB. 

We're running 2 applications, `devops-example-working` and `devops-example-broken`. After a recent change `devops-example-broken` is unsurprisingly broken. When testing the application on `example.dyedurham.dev/api/devops-example-broken` you are getting 504 Gateway Timeout error, the pod status of `devops-example-broken` is;

```bash
$ kubectl get pods
NAME                                     READY   STATUS    RESTARTS   AGE
devops-example-broken-578d85685b-fhv75   1/1     Running   0          154m
```

Normally you could just look at the git history to find the issue, but this would be too easy so we've eliminated this by it not being a git repo. This is designed to test that you understand kubernetes enough to be able to spot configuration issues.

## Things to Prep for your interview

* Describe why `devops-example-broken` is broken.
* Describe how you'd prevent this issue occuring again.
* Currently these are just yaml files in a directory. Describe what you'd do to pipeline the deployment via a CI/CD process (or equivalent).
* Propose at least 1 change to the application yaml to improve something.
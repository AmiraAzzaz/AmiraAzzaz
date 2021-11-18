MONGODB / MONGOEXPRESS ON KUBERNETES

-->MongoDB secrets:
Create secret:
I created a secret in a file first, in json or yaml format, then created this object. The secret contains two hash tables: data and stringData. The data field is used to store arbitrary data, encoded in base64. The stringData field is provided for convenience and is used to provide secret data as unencrypted strings
My-mongodb-secret.yaml


-->MongoDB deployment:
*Define mongodb container environment variables using Secret data
My-mongodb-deployment.yaml:
 
*Define an internel service
A service in Kubernetes is a REST object, similar to a pod. Like all REST objects, you can POST a service definition to the API server to create a new instance.
For our example, we have a set of pods that each listen on TCP port 27017 and have a label app=mongodb:
This specification creates a new Service object named "mongo-service", which targets TCP port 27017 on any pod with the tag "app=mongodb".
Kubernetes assigns this service an IP address, which is used by Service proxies. The service controller continuously searches for pods that match its selector(mongodb in our case), and then POSTs all updates to an Endpoint object also called " mongo-service ".
 
-->Mongo express configmap:
A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.
A ConfigMap allows as to decouple environment-specific configuration from our mango-express container images, so that our applications are easily portable.
My-mongo-configmap.yaml:

-->Mongo express deployment:
My-mongo-express-deployement.yaml:
 
And finally, we added the mango-express external service:
 
And it works.

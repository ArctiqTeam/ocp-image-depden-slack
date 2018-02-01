# ocp-image-depden-slack
Grab image dependencies from OpenShift cluster and output to Slack. 

The script is meant to help with the image update process. You can get a  list of all dependencies or just a single image stream tag. Once you have the dependencies you can plan your update process. If default build/deployment config settings are in place an image update could cause a mass building/deployment of images

Be sure to:
`export slackwebhook=XXXXX`

To make sure your Slack Web Hook code is loaded into env variables so the script can use it.

## Info
- The script is currently only querying image dependencies in the openshift project. The assumption is that the base image for your pod lives there.

- The script is using the `oc adm build-chain` command which is checking the build config dependencies and only outputting if there is a image change trigger in the build config. The script isn’t currently checking deployment configs or if the build config image change trigger is false.

- By default deployment configs are set to redeploy on image change. If this has been manually changed to false than an image update could cause your build config to build a new image but not deploy it.

## Usage

The script works in two ways. To generate a report of all image dependencies in the openshift project or just give you the dependencies of a provided image tag.
```
phil@c3po]$ dpen-report.sh image httpd:2.4
Querying Openshift and loading message
<openshift istag/httpd:2.4> <test bc/httpd-ex> <test istag/httpd-ex:latest>

Script is done loading, sending output to slack
``` 
OR
```
[phil@c3po]$ dpen-report.sh report
Querying Openshift and loading message
```

The script will output to the console as well as to Slack.

## Updating the image

`oc import-image <image stream tag or image stream>`

## Handy Commands

- **oc adm build-chain**
```
phil@c3po ocp-image-depden-slack]$ oc adm build-chain httpd:2.4 -n openshift --all --trigger-only=false
<openshift istag/httpd:2.4>
        <test bc/httpd-ex>
                <test istag/httpd-ex:latest>
```

- **oc set triggers** (get triggers for bc or dc and change if needed)
```
oc set triggers dc/httpd-ex
NAME                        TYPE    VALUE                       AUTO
deploymentconfigs/httpd-ex  config                              true
deploymentconfigs/httpd-ex  image   httpd-ex:latest (httpd-ex)  false
```

## Refrences
https://api.slack.com/docs/message-attachments

https://api.slack.com/docs/messages

https://blog.openshift.com/image-streams-faq/

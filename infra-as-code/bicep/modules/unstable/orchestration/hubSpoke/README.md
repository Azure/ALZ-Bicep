# Module: Orchestration - Hub and Spoke (aka. Adventure Works)

> 🚨⚠️🚨 **This module does not work today due to the following Bicep/ARM bugs, [5371](https://github.com/Azure/bicep/issues/5371) & [5412](https://github.com/Azure/bicep/issues/5412), that we are working with engineering teams to resolve ASAP** 🚨⚠️🚨

This module acts as an orchestration module that glues all the individual module deployments together the deliver the Azure Landing Zone Hub & Spoke architecture *(a.k.a. Adventure Works)* which is also described in the wiki on the [Deployment Flow article](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow).

As the warning at the top of this `README.md` states this module does not actually work today as a single deployment due to some bugs in Bicep/ARM that we are working closely with the Bicep & ARM engineering teams to resolve. The bugs are for awareness:

- [5371 - Deployment validation false positive validating tenant-level template deploying a managementGroup](https://github.com/Azure/bicep/issues/5371)
- [5412 - Multiple issues with json(loadTextContent('...')) resulting in large/bloated built ARM templates that can be larger than 4MB](https://github.com/Azure/bicep/issues/5412)

## So why provide a non-working orchestration module?

Good question! We decided to provide this orchestration module as an example even though it doesn't work itself as it still provides a great example of how to stitch a lot of the modules together. For example, how you use the logging module to deploy a Log Analytics Workspace and then get it's ID as an output and pass it into the required Policy Assignment Parameters.

We also realise that many of you using these modules will not want to deploy them in a single deployment and will want to split modules up into multiple deployments/pipelines etc. Hence why it is not critical for this orchestration template to be working to prevent us from getting these modules out to you all👍

<!-- markdownlint-disable -->
## Azure Landing Zones Bicep - FAQ
<!-- markdownlint-restore -->

This wiki page answers frequently asked questions (FAQs) relating to the Azure Landing Zones Bicep modules.

Some FAQ questions that relate more to the architecture are based over in the CAF docs here: [Enterprise-scale architecture FAQ](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/faq)

> Log an issue or create a pull request if you have a question that is not answered here, we are happy to help and have community contributions 👍

## List of Frequently Asked Questions

- [Why are some linter rules disabled via the `#disable-next-line` Bicep function?](#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function)

---

## Questions & Answers

## Why are some linter rules disabled via the `#disable-next-line` Bicep function?

In some of the ALZ-Bicep modules some of linter rules are disabled using the `#disable-next-line` Bicep feature. Today, this is primarily for disabling the [no-loc-expr-outside-params linter rule](https://docs.microsoft.com/azure/azure-resource-manager/bicep/linter-rule-no-loc-expr-outside-params) for the, optional, telemetry module as we want to ensure this telemetry deployment is stored in the same location as specified by the `location` input when deploying the Bicep module, instead of in the same location as specified by `parLocation` as this may be different from the region targeted by the deployment to ARM.

You may also see it in some location for resources that do not require a region for deployment, like Azure Policies, so instead of making users input an additional parameter for the region, we just use the one that was targeted by the deployment to ARM when the module was deployed.

It is not recommended to disable linter rules when it can be resolved by making changes to the Bicep code. However, in some scenarios, like above, this is necessary.
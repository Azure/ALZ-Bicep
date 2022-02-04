# Why Does This Directory Exist & Contain Other Bicep Modules?

Good question! This directory exists to host modules that are **not** specific to the Azure Landing Zones modules that are contained within the `infra-as-code/bicep/modules` directory.

The modules inside this directory, `infra-as-code/bicep/CRML` are modules that we are potentially planning, at some point in time, to remove from this repo and migrate/consume them from the [Common Azure Resource Modules Library repo](https://github.com/Azure/ResourceModules) when features like the Bicep Public Module Registry exists.

> These are only plans/aspirations at this stage, but we are sharing with you for clarity 👍

These modules are consumed and called by other modules within this repo. For example, the `customerUsageAttribution` module is called in all modules as you can see from each of those modules `.bicep` files.
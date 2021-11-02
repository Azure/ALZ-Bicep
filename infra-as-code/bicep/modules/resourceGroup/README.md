# Module: Resource Group

This module creates a Resource group to be utilized by other modules.  

Module deploys the following resources:

- Resource Group

## Parameters

The module requires the following inputs:

 Parameter | Type | Default | Description | Requirement | Example
----------- | ---- | ------- |----------- | ----------- | -------
 parResourceGroupLocation  | string | None | Location where Resource Group will be deployed | Valid Azure Region | eastus2
 parResourceGroupName | string| None | Name of Resource Group to create in the specified region| 2-64 char, letters, numbers, and underscores | Hub

## Outputs

The module will generate the following outputs:

Output | Type | Example
------ | ---- | --------

## Deployment

Module is intended to be called from other modules as a reusable resource.

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
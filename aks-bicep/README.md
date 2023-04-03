# Bicep file for creating AKS cluster

# expose the app
az aks addon enable --name devnexus2023cluster --addon http_application_routing -g devnexus-aks-rg
az aks show -g devnexus-aks-rg -n devnexus2023cluster -o table --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName



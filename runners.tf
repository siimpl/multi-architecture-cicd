resource "helm_release" "arc" {
  name      = "arc"
  chart     = "oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller"
  namespace = "arc-systems"
  create_namespace = true
  timeout   = 120

  depends_on = [azurerm_kubernetes_cluster.cicd]
}

resource "helm_release" "arc_runner_set_amd64" {
  name      = "arc-runner-set-amd64"
  chart     = "oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set"
  namespace = "arc-runners"
  create_namespace = true
  timeout   = 120

  values = [
    templatefile("./templatefiles/arc_runner_values.yaml", {
      github_config_url = var.github_config.config_url
      github_pat = var.github_config.pat
      architecture = "amd64"
    })
  ]

  depends_on = [helm_release.arc]
}

resource "helm_release" "arc_runner_set_arm64" {
  name      = "arc-runner-set-arm64"
  chart     = "oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set"
  namespace = "arc-runners"
  create_namespace = true
  timeout   = 120

  values = [
    templatefile("./templatefiles/arc_runner_values.yaml", {
      github_config_url = var.github_config.config_url
      github_pat = var.github_config.pat
      architecture = "arm64"
    })
  ]

  depends_on = [helm_release.arc]
}
# language: zh-CN
@allure.label.epic:nexus-chart-deploy
@nexus-chart-deploy-network
功能: 支持多种网络模式部署 nexus

  @automated
  @priority-high
  @nexus-chart-deploy-network-http
  @allure.label.case_id:nexus-chart-deploy-network-http
  场景: 使用 http 方式部署 nexus
    假定 集群已安装 ingress controller
    并且 已添加域名解析
      | domain                        | ip           |
      | test-ingress-http.example.com | <ingress-ip> |
    并且 命名空间 "nexus-network-http" 已存在
    并且 已导入 "password" 资源: "./testdata/resources/secret-password.yaml"
    当 使用 helm 部署实例到 "nexus-network-http" 命名空间
      """
      chartPath: ../
      releaseName: nexus-http
      values:
      - testdata/snippets/base-values.yaml
      - testdata/snippets/values-storage-hostpath.yaml
      - testdata/snippets/values-network-ingress-http.yaml
      """
    并且 "nexus" 可以正常访问
      """
      url: http://admin:Nexus12345@test-ingress-http.example.com/service/rest/v1/status/check
      timeout: 10m
      """

  @automated
  @priority-high
  @nexus-chart-deploy-network-https
  @allure.label.case_id:nexus-chart-deploy-network-https
  场景: 使用 https 方式部署 nexus
    假定 集群已安装 ingress controller
    并且 已添加域名解析
      | domain                         | ip           |
      | test-ingress-https.example.com | <ingress-ip> |
    并且 命名空间 "nexus-network-https" 已存在
    并且 已导入 "password" 资源: "./testdata/resources/secret-password.yaml"
    并且 已导入 "tls 证书" 资源: "./testdata/resources/secret-tls-cert.yaml"
    当 使用 helm 部署实例到 "nexus-network-https" 命名空间
      """
      chartPath: ../
      releaseName: nexus-https
      values:
      - testdata/snippets/base-values.yaml
      - testdata/snippets/values-storage-hostpath.yaml
      - testdata/snippets/values-network-ingress-https.yaml
      """
    并且 "nexus" 可以正常访问
      """
      url: https://admin:Nexus12345@test-ingress-https.example.com/service/rest/v1/status/check
      timeout: 10m
      """

  @automated
  @priority-high
  @nexus-chart-deploy-network-nodeport
  @allure.label.case_id:nexus-chart-deploy-network-nodeport
  场景: 使用 nodeport 方式部署 nexus
    假定 命名空间 "nexus-network-nodeport" 已存在
    并且 已导入 "password" 资源: "./testdata/resources/secret-password.yaml"
    当 使用 helm 部署实例到 "nexus-network-nodeport" 命名空间
      """
      chartPath: ../
      releaseName: nexus-nodeport
      values:
      - testdata/snippets/base-values.yaml
      - testdata/snippets/values-storage-hostpath.yaml
      - testdata/snippets/values-network-nodeport.yaml
      """
    并且 "nexus" 可以正常访问
      """
      url: http://admin:Nexus12345@<node.first>:<nodeport.http>/service/rest/v1/status/check
      timeout: 10m
      """

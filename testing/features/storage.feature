# language: zh-CN

@allure.label.epic:nexus-chart-deploy
@nexus-chart-deploy-storage
功能: 支持多种存储类型部署 nexus

  @smoke
  @automated
  @priority-high
  @allure.label.case_id:nexus-chart-deploy-storage-sc
  场景: 使用存储类方式部署 nexus
    假定 集群已存在存储类
    并且 命名空间 "nexus-storage-sc" 已存在
    并且 已导入 "password" 资源: "./testdata/resources/secret-password.yaml"
    当 使用 helm 部署实例到 "nexus-storage-sc" 命名空间
      """
      chartPath: ../
      releaseName: nexus-sc
      values:
      - testdata/snippets/base-values.yaml
      - testdata/snippets/values-network-nodeport.yaml
      - testdata/snippets/values-storage-sc.yaml
      """
    并且 "nexus" 可以正常访问
      """
      url: http://admin:Nexus12345@<node.first>:<nodeport.http>/service/rest/v1/status/check
      timeout: 10m
      """
    并且 Pod 资源检查通过
      | name                 | path                                                                         | value                         |
      | nexus-sc-nxrm-ha-0   | $.spec.volumes[?(@.name == 'nexus-data')][0].persistentVolumeClaim.claimName | nexus-data-nexus-sc-nxrm-ha-0 |

  @automated
  @priority-high
  @allure.label.case_id:nexus-chart-deploy-storage-hostpath
  场景: 使用 hostpath 方式部署 nexus
    假定 命名空间 "nexus-storage-hostpath" 已存在
    并且 已导入 "password" 资源: "./testdata/resources/secret-password.yaml"
    当 使用 helm 部署实例到 "nexus-storage-hostpath" 命名空间
      """
      chartPath: ../
      releaseName: nexus-hostpath
      values:
      - testdata/snippets/base-values.yaml
      - testdata/snippets/values-network-nodeport.yaml
      - testdata/snippets/values-storage-hostpath.yaml
      """
    并且 "nexus" 可以正常访问
      """
      url: http://admin:Nexus12345@<node.ip.random.readable>:<nodeport.http>/service/rest/v1/status/check
      timeout: 10m
      """
    并且 Pod 资源检查通过
      | name                       | path            | value        |
      | nexus-hostpath-nxrm-ha-0   | $.status.hostIP | <node.ip.random.readable> |

  @automated
  @priority-high
  @allure.label.case_id:nexus-chart-deploy-storage-pvc
  场景: 使用指定 pvc 的方式部署 nexus
    假定 命名空间 "nexus-storage-pvc" 已存在
    并且 已导入 "password" 资源: "./testdata/resources/secret-password.yaml"
    并且 已导入 "pvc" 资源: "./testdata/resources/storage-pvc.yaml"
    当 使用 helm 部署实例到 "nexus-storage-pvc" 命名空间
      """
      chartPath: ../
      releaseName: nexus-pvc
      values:
      - testdata/snippets/base-values.yaml
      - testdata/snippets/values-network-nodeport.yaml
      - testdata/snippets/values-storage-pvc.yaml
      """
    并且 "nexus" 可以正常访问
      """
      url: http://admin:Nexus12345@<node.first>:<nodeport.http>/service/rest/v1/status/check
      timeout: 10m
      """
    并且 Pod 资源检查通过
      | name                  | path                                                                         | value       |
      | nexus-pvc-nxrm-ha-0   | $.spec.volumes[?(@.name == 'nexus-data')][0].persistentVolumeClaim.claimName | nexus-pvc   |

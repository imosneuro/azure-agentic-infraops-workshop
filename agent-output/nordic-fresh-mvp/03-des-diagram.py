from diagrams import Diagram, Cluster, Edge
from diagrams.azure.compute import AppServices
from diagrams.azure.database import SQLDatabases
from diagrams.azure.identity import ManagedIdentities
from diagrams.azure.security import KeyVaults
from diagrams.azure.storage import StorageAccounts
from diagrams.azure.network import FrontDoors
from diagrams.azure.devops import ApplicationInsights
from diagrams.azure.monitor import Monitor
from diagrams.onprem.client import Users

with Diagram(
    "Nordic Fresh MVP Solution Architecture",
    filename="agent-output/nordic-fresh-mvp/03-des-diagram",
    show=False,
    direction="LR",
    graph_attr={"nodesep": "1.0", "ranksep": "1.0", "splines": "spline"}
):
    n_edge_user = Users("Consumer/Partner")
    with Cluster("Azure Front Door / Edge", graph_attr={"label": "Boundary: Edge"}):
        n_edge_fd = FrontDoors("Front Door + WAF")
    with Cluster("Web Tier", graph_attr={"label": "Boundary: Web/API"}):
        n_web_app = AppServices("App Service (Linux)")
        n_web_ai = ApplicationInsights("App Insights")
        n_web_mi = ManagedIdentities("Managed Identity")
    with Cluster("Data Tier", graph_attr={"label": "Boundary: Data"}):
        n_data_sql = SQLDatabases("SQL DB")
        n_data_storage = StorageAccounts("Storage (Hot LRS)")
        n_data_kv = KeyVaults("Key Vault")
    with Cluster("Ops/Security", graph_attr={"label": "Boundary: Ops/Sec"}):
        n_ops_monitor = Monitor("Azure Monitor")

    # User to Edge
    n_edge_user >> Edge(label="HTTPS request", color="blue") >> n_edge_fd
    # Edge to Web
    n_edge_fd >> Edge(label="Route + WAF", color="blue") >> n_web_app
    # Web to Data
    n_web_app >> Edge(label="SQL auth/query", color="purple") >> n_data_sql
    n_web_app >> Edge(label="Blob/file", color="purple") >> n_data_storage
    n_web_app >> Edge(label="Secret fetch", color="orange") >> n_data_kv
    # Web to Identity
    n_web_app >> Edge(label="MSI auth", style="dashed", color="green") >> n_web_mi
    # Web to Telemetry
    n_web_app >> Edge(label="Telemetry", style="dotted", color="red") >> n_web_ai
    n_web_app >> Edge(label="Metrics/logs", style="dotted", color="red") >> n_ops_monitor
    # Data to Ops
    n_data_sql >> Edge(label="Audit logs", style="dotted", color="red") >> n_ops_monitor
    n_data_storage >> Edge(label="Access logs", style="dotted", color="red") >> n_ops_monitor
    n_data_kv >> Edge(label="Access logs", style="dotted", color="red") >> n_ops_monitor

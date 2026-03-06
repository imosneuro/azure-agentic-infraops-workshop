from diagrams import Diagram, Cluster
from diagrams.azure.compute import AppServices
from diagrams.azure.database import SQLDatabases
from diagrams.azure.identity import ManagedIdentities
from diagrams.azure.security import KeyVaults
from diagrams.azure.storage import StorageAccounts
from diagrams.azure.network import FrontDoors
from diagrams.azure.devops import ApplicationInsights
from diagrams.azure.monitor import Monitor

with Diagram(
    "Nordic Fresh MVP Dependency Graph",
    filename="agent-output/nordic-fresh-mvp/04-dependency-diagram",
    show=False,
    direction="TB",
    graph_attr={"nodesep": "1.0", "ranksep": "1.0", "splines": "spline"}
):
    with Cluster("Web/API Tier"):
        app_service = AppServices("App Service")
        app_insights = ApplicationInsights("App Insights")
        managed_identity = ManagedIdentities("Managed Identity")
    with Cluster("Data Tier"):
        sql_db = SQLDatabases("SQL DB")
        storage = StorageAccounts("Storage")
        key_vault = KeyVaults("Key Vault")
    with Cluster("Edge Tier"):
        front_door = FrontDoors("Front Door")
    monitor = Monitor("Azure Monitor")

    # Dependencies
    front_door >> app_service
    app_service >> sql_db
    app_service >> storage
    app_service >> key_vault
    app_service >> managed_identity
    app_service >> app_insights
    app_service >> monitor
    sql_db >> monitor
    storage >> monitor
    key_vault >> monitor

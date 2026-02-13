"""
Architecture Diagram: team-leaderboard
=======================================
Generates a PNG architecture diagram for the hackathon scoring leaderboard app.

Architecture: Azure Static Web Apps (Standard) + Azure Table Storage

Prerequisites:
    pip install diagrams matplotlib pillow
    apt-get install -y graphviz  # Ubuntu/Debian

Generate:
    cd agent-output/team-leaderboard
    python3 03-des-diagram.py
"""

from diagrams import Diagram, Cluster, Edge
from diagrams.azure.web import AppServices
from diagrams.azure.compute import FunctionApps
from diagrams.azure.storage import TableStorage, StorageAccounts
from diagrams.azure.identity import ActiveDirectory
from diagrams.azure.devops import Repos
from diagrams.azure.general import Resourcegroups
from diagrams.onprem.client import Users

# Professional diagram settings
graph_attr = {
    "bgcolor": "white",
    "pad": "0.8",
    "nodesep": "1.0",
    "ranksep": "1.0",
    "splines": "spline",
    "fontname": "Arial Bold",
    "fontsize": "18",
    "dpi": "150",
    "label": "team-leaderboard | Design Architecture\nAzure Static Web Apps + Table Storage",
    "labelloc": "t",
    "labeljust": "c",
}

node_attr = {
    "fontname": "Arial Bold",
    "fontsize": "11",
    "labelloc": "t",
}

cluster_style = {
    "margin": "30",
    "fontname": "Arial Bold",
    "fontsize": "14",
}

rg_style = {
    **cluster_style,
    "bgcolor": "#F0F6FF",
    "style": "rounded",
}

with Diagram(
    "",
    filename="03-des-diagram",
    direction="TB",
    show=False,
    outformat="png",
    graph_attr=graph_attr,
    node_attr=node_attr,
):

    # External actors
    facilitators = Users("Facilitators\n(GitHub Auth)")
    participants = Users("Participants\n(Read-Only)")
    github = Repos("GitHub Repo\n(CI/CD Source)")

    with Cluster("Azure Subscription", graph_attr=cluster_style):

        with Cluster("rg-team-leaderboard-prod\n(swedencentral)", graph_attr=rg_style):

            with Cluster("Azure Static Web Apps\nstapp-team-leaderboard-prod\n(Standard, westeurope)", graph_attr={
                **cluster_style,
                "bgcolor": "#E8F4FD",
                "style": "rounded",
            }):
                swa_frontend = AppServices("SPA Frontend\n(React/Vue)")
                swa_auth = ActiveDirectory("GitHub OAuth\n(Built-in Auth)")
                swa_api = FunctionApps("Managed Functions\n/api/teams\n/api/scores\n/api/awards")

            with Cluster("Data Tier\nswedencentral", graph_attr={
                **cluster_style,
                "bgcolor": "#E8F5E9",
                "style": "rounded",
            }):
                storage = StorageAccounts("stteamlbrdprod{suffix}\nStandard LRS")
                table_teams = TableStorage("Teams Table")
                table_scores = TableStorage("Scores Table")
                table_awards = TableStorage("Awards Table")

    # Data flow: Users → SWA
    facilitators >> Edge(label="HTTPS\n(score entry)", color="#0078D4") >> swa_frontend
    participants >> Edge(label="HTTPS\n(leaderboard)", color="#107C10", style="dashed") >> swa_frontend

    # Auth flow
    swa_frontend >> Edge(label="Auth check", style="dashed", color="#5C2D91") >> swa_auth

    # Frontend → API
    swa_frontend >> Edge(label="REST API\ncalls", color="#0078D4") >> swa_api

    # API → Storage
    swa_api >> Edge(label="Read/Write", color="#D83B01") >> storage
    storage >> table_teams
    storage >> table_scores
    storage >> table_awards

    # CI/CD
    github >> Edge(label="GitHub Actions\n(auto-deploy)", style="dashed", color="#6F42C1") >> swa_frontend

print("✅ Diagram generated: 03-des-diagram.png")

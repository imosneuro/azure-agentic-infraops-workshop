"""
User Flow Diagram: team-leaderboard
=====================================
Swimlane process flow showing how facilitators and participants
interact with the scoring system — manual entry, JSON upload, 
leaderboard viewing, and award assignment.

Prerequisites:
    pip install graphviz
    apt-get install -y graphviz

Generate:
    cd agent-output/team-leaderboard
    python3 03-des-user-flow.py
"""

from graphviz import Digraph

dot = Digraph("Team Leaderboard - User Flow", format="png")
dot.attr(
    rankdir="TB",
    compound="true",
    bgcolor="white",
    pad="0.8",
    nodesep="0.6",
    ranksep="0.7",
    fontname="Arial Bold",
    fontsize="18",
    label="team-leaderboard | Scoring User Flow\nWho does what, when, and how",
    labelloc="t",
    labeljust="c",
    dpi="150",
)
dot.attr("node", fontname="Segoe UI", fontsize="10")
dot.attr("edge", fontname="Segoe UI", fontsize="9")

# --- Style presets ---
START_END = {"shape": "ellipse", "style": "filled", "fillcolor": "#E8F5E9", "color": "#4CAF50", "fontname": "Segoe UI Bold"}
USER_ACTION = {"shape": "box", "style": "filled,rounded", "fillcolor": "#F3E5F5", "color": "#9C27B0", "fontname": "Segoe UI"}
SYSTEM = {"shape": "box", "style": "filled,rounded", "fillcolor": "#E3F2FD", "color": "#2196F3", "fontname": "Segoe UI"}
DECISION = {"shape": "diamond", "style": "filled", "fillcolor": "#FFF8E1", "color": "#FFC107", "fontname": "Segoe UI"}
DATA = {"shape": "cylinder", "style": "filled", "fillcolor": "#FBE9E7", "color": "#FF5722", "fontname": "Segoe UI"}
DOCUMENT = {"shape": "note", "style": "filled", "fillcolor": "#FFFDE7", "color": "#FFEB3B", "fontname": "Segoe UI"}
DISPLAY = {"shape": "box", "style": "filled,rounded", "fillcolor": "#E0F7FA", "color": "#00BCD4", "fontname": "Segoe UI"}

# ============================================================
# SWIMLANE 1: Facilitator
# ============================================================
with dot.subgraph(name="cluster_facilitator") as fac:
    fac.attr(
        label="👤 Admin (Authenticated via GitHub)",
        style="filled",
        fillcolor="#F3E5F5",
        color="#9C27B0",
        fontname="Arial Bold",
        fontsize="14",
        margin="20",
    )

    fac.node("start", "Microhack\nStarts", **START_END)
    fac.node("login", "Login via\nGitHub OAuth", **USER_ACTION)
    fac.node("create_teams", "Create Teams\nin the App", **USER_ACTION)
    fac.node("choose_method", "How to\nscore?", **DECISION)

    # Path A: Manual entry
    fac.node("manual_entry", "Enter Scores\nManually\n(Form UI)", **USER_ACTION)
    fac.node("select_team", "Select Team\n& Category", **USER_ACTION)
    fac.node("enter_points", "Enter Points\nper Criterion", **USER_ACTION)
    fac.node("enter_bonus", "Enter Bonus\nPoints\n(if applicable)", **USER_ACTION)

    # Path B: JSON upload
    fac.node("run_script", "Run\nScore-Team.ps1\nLocally", **USER_ACTION)
    fac.node("json_file", "score-results.json\n(generated)", **DOCUMENT)
    fac.node("upload_json", "Drag & Drop\nJSON File\ninto App", **USER_ACTION)
    fac.node("preview", "Preview\nImported Scores", **DISPLAY)
    fac.node("confirm_import", "Confirm\nImport?", **DECISION)

    # Awards
    fac.node("assign_awards", "Assign Awards\n🏆 Best Overall\n🛡️ Security Champion\n💰 Cost Optimizer\n📐 Best Architecture\n🚀 Speed Demon", **USER_ACTION)

# ============================================================
# SWIMLANE 2: System (Azure Static Web Apps + Functions)
# ============================================================
with dot.subgraph(name="cluster_system") as sys:
    sys.attr(
        label="⚡ System (Azure Static Web Apps + Functions API)",
        style="filled",
        fillcolor="#E3F2FD",
        color="#2196F3",
        fontname="Arial Bold",
        fontsize="14",
        margin="20",
    )

    sys.node("auth_check", "Validate\nGitHub Token\n& Role", **SYSTEM)
    sys.node("validate_json", "Validate JSON\nStructure &\nScore Ranges", **SYSTEM)
    sys.node("api_save", "POST /api/scores\nSave to Storage", **SYSTEM)
    sys.node("calc_totals", "Calculate Totals\nPercentages\n& Grades", **SYSTEM)
    sys.node("update_board", "Update\nLeaderboard\nRankings", **SYSTEM)
    sys.node("api_awards", "POST /api/awards\nSave Awards", **SYSTEM)

# ============================================================
# SWIMLANE 3: Data Store
# ============================================================
with dot.subgraph(name="cluster_data") as data:
    data.attr(
        label="💾 Azure Table Storage (westeurope)",
        style="filled",
        fillcolor="#FBE9E7",
        color="#FF5722",
        fontname="Arial Bold",
        fontsize="14",
        margin="20",
    )

    data.node("store_teams", "Teams Table", **DATA)
    data.node("store_attendees", "Attendees Table", **DATA)
    data.node("store_scores", "Scores Table", **DATA)
    data.node("store_awards", "Awards Table", **DATA)

# ============================================================
# SWIMLANE 4: Participant (Read-Only)
# ============================================================
with dot.subgraph(name="cluster_participant") as part:
    part.attr(
        label="👥 Readers (Authenticated, Read-Only)",
        style="filled",
        fillcolor="#E0F7FA",
        color="#00BCD4",
        fontname="Arial Bold",
        fontsize="14",
        margin="20",
    )

    part.node("view_board", "View Live\nLeaderboard\n📊", **DISPLAY)
    part.node("view_scores", "View Own\nTeam Score\nBreakdown", **DISPLAY)
    part.node("view_grade", "See Grade\n🏆 Outstanding\n🥇 Excellent\n🥈 Good\n🥉 Satisfactory\n📚 Needs Improvement", **DISPLAY)
    part.node("view_awards", "See Award\nWinners 🏆", **DISPLAY)
    part.node("end", "Microhack\nEnds", **START_END)

# ============================================================
# EDGES: Main Flow
# ============================================================

# Facilitator login flow
dot.edge("start", "login", label="1. Begin")
dot.edge("login", "auth_check", label="GitHub OAuth")
dot.edge("auth_check", "create_teams", label="Role: admin")
dot.edge("create_teams", "store_teams", label="POST /api/teams", style="dashed", color="#FF5722")
dot.edge("create_teams", "choose_method", label="2. Start scoring")

# Decision: Manual vs Upload
dot.edge("choose_method", "manual_entry", label="Manual\nEntry", color="#9C27B0")
dot.edge("choose_method", "run_script", label="JSON\nUpload", color="#6F42C1")

# Path A: Manual entry flow
dot.edge("manual_entry", "select_team")
dot.edge("select_team", "enter_points")
dot.edge("enter_points", "enter_bonus")
dot.edge("enter_bonus", "api_save", label="Submit", color="#2196F3")

# Path B: JSON upload flow
dot.edge("run_script", "json_file", label="Generates")
dot.edge("json_file", "upload_json", label="Drag & drop")
dot.edge("upload_json", "validate_json", label="Upload", color="#2196F3")
dot.edge("validate_json", "preview", label="Valid ✅")
dot.edge("validate_json", "upload_json", label="Invalid ❌\nRetry", style="dashed", color="#F44336")
dot.edge("preview", "confirm_import")
dot.edge("confirm_import", "api_save", label="Yes ✅", color="#4CAF50")
dot.edge("confirm_import", "upload_json", label="No ❌\nRe-upload", style="dashed", color="#F44336")

# System processing
dot.edge("api_save", "store_scores", label="Write", color="#FF5722")
dot.edge("api_save", "calc_totals", label="3. Auto-calculate")
dot.edge("calc_totals", "update_board", label="Rank teams")

# Awards flow
dot.edge("update_board", "assign_awards", label="4. Assign awards", style="dashed")
dot.edge("assign_awards", "api_awards", label="Save", color="#2196F3")
dot.edge("api_awards", "store_awards", label="Write", color="#FF5722")

# Participant view flow (reads)
dot.edge("update_board", "view_board", label="Real-time\nupdate", color="#00BCD4")
dot.edge("view_board", "view_scores", label="Click team")
dot.edge("view_scores", "view_grade", label="See grade")
dot.edge("api_awards", "view_awards", label="Awards\nannounced", color="#00BCD4", style="dashed")
dot.edge("view_awards", "end", label="5. Done")

# Render
dot.render("03-des-user-flow", cleanup=True)
print("✅ User flow diagram generated: 03-des-user-flow.png")

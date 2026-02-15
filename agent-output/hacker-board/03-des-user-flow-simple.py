"""
User Flow Diagram (Simplified Cartoon Style): hacker-board
================================================================
A fun, easy-to-read overview of the scoring workflow.

Prerequisites:
    pip install graphviz
    apt-get install -y graphviz

Generate:
    cd agent-output/hacker-board
    python3 03-des-user-flow-simple.py
"""

from graphviz import Digraph

dot = Digraph("Scoring Flow", format="png")
dot.attr(
    rankdir="LR",
    bgcolor="#FFFEF5",
    pad="1.0",
    nodesep="0.8",
    ranksep="1.2",
    splines="spline",
    fontname="Comic Sans MS, Arial Rounded MT Bold, Arial",
    fontsize="22",
    label="🏆 How Scoring Works 🏆",
    labelloc="t",
    labeljust="c",
    dpi="150",
)
dot.attr("node", fontname="Comic Sans MS, Arial Rounded MT Bold, Arial", fontsize="13", penwidth="2.5")
dot.attr("edge", fontname="Comic Sans MS, Arial Rounded MT Bold, Arial", fontsize="11", penwidth="2.0")

# Color palette (bright, cartoon-style)
PINK = "#FF6B9D"
BLUE = "#4ECDC4"
YELLOW = "#FFE66D"
ORANGE = "#FF8C42"
PURPLE = "#A855F7"
GREEN = "#22C55E"
RED = "#EF4444"
SKY = "#7DD3FC"

# ============================================================
# Step 1: Facilitator logs in
# ============================================================
dot.node("facilitator", "👩‍💻 Admin\nlogs in with\nGitHub",
         shape="box", style="filled,rounded,bold", fillcolor=PINK, color="#E11D48",
         fontcolor="white", width="1.8", height="1.2")

# ============================================================
# Step 2: Create teams
# ============================================================
dot.node("teams", "👥 Create\nTeams",
         shape="box", style="filled,rounded,bold", fillcolor=PURPLE, color="#7C3AED",
         fontcolor="white", width="1.5", height="1.0")

# ============================================================
# Step 3: Choose how to score
# ============================================================
dot.node("choose", "🤔 How to\nscore?",
         shape="diamond", style="filled,bold", fillcolor=YELLOW, color="#CA8A04",
         fontcolor="#713F12", width="1.8", height="1.4")

# Path A: Manual
dot.node("manual", "✍️ Type scores\nin the form",
         shape="box", style="filled,rounded,bold", fillcolor=SKY, color="#0284C7",
         fontcolor="#0C4A6E", width="1.8", height="1.0")

# Path B: Upload
dot.node("upload", "📂 Upload\nJSON file\n(drag & drop!)",
         shape="box", style="filled,rounded,bold", fillcolor=SKY, color="#0284C7",
         fontcolor="#0C4A6E", width="1.8", height="1.0")

# ============================================================
# Step 4: System crunches numbers
# ============================================================
dot.node("magic", "🪄 App calculates\ntotals, grades\n& rankings",
         shape="box", style="filled,rounded,bold", fillcolor=ORANGE, color="#C2410C",
         fontcolor="white", width="2.0", height="1.2")

# ============================================================
# Step 5: Leaderboard updates
# ============================================================
dot.node("leaderboard", "📊 Live\nLeaderboard\nupdates!",
         shape="box", style="filled,rounded,bold", fillcolor=GREEN, color="#15803D",
         fontcolor="white", width="1.8", height="1.2")

# ============================================================
# Step 6: Awards
# ============================================================
dot.node("awards", "🏆 Assign\nAwards\n🛡️💰📐🚀",
         shape="box", style="filled,rounded,bold", fillcolor=YELLOW, color="#CA8A04",
         fontcolor="#713F12", width="1.8", height="1.2")

# ============================================================
# Participants
# ============================================================
dot.node("participants", "🎉 Readers\nsee scores\n& celebrate!",
         shape="box", style="filled,rounded,bold", fillcolor=BLUE, color="#0D9488",
         fontcolor="white", width="2.0", height="1.2")

# ============================================================
# EDGES
# ============================================================
dot.edge("facilitator", "teams", label=" 1️⃣ ", color=PINK, penwidth="3")
dot.edge("teams", "choose", label=" 2️⃣ ", color=PURPLE, penwidth="3")
dot.edge("choose", "manual", label="✍️ by hand", color="#0284C7", penwidth="2.5")
dot.edge("choose", "upload", label="📂 JSON file", color="#0284C7", penwidth="2.5")
dot.edge("manual", "magic", label=" 3️⃣ ", color=ORANGE, penwidth="3")
dot.edge("upload", "magic", label=" 3️⃣ ", color=ORANGE, penwidth="3")
dot.edge("magic", "leaderboard", label=" 4️⃣ ", color=GREEN, penwidth="3")
dot.edge("leaderboard", "awards", label=" 5️⃣ ", color="#CA8A04", penwidth="3")
dot.edge("leaderboard", "participants", label=" everyone\n sees it! ", color=BLUE, style="dashed", penwidth="2.5")
dot.edge("awards", "participants", label=" 🎉 ", color=BLUE, penwidth="3")

# Render
dot.render("03-des-user-flow-simple", cleanup=True)
print("✅ Cartoon user flow generated: 03-des-user-flow-simple.png")

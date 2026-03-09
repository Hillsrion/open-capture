import os
import subprocess
import time

ARTICLES = [
    ("UserInterface", "User_interface_overview", "https://support.captureone.com/hc/en-us/articles/360002468797-User-interface-overview"),
    ("UserInterface", "The_Viewer_overview", "https://support.captureone.com/hc/en-us/articles/360002468897-The-Viewer-overview"),
    ("UserInterface", "The_Browser_overview", "https://support.captureone.com/hc/en-us/articles/360002474018-The-Browser-overview"),
    ("UserInterface", "Workspace_layouts", "https://support.captureone.com/hc/en-us/articles/360002470117-Workspace-layouts"),
    ("UserInterface", "Tool_Tabs_overview", "https://support.captureone.com/hc/en-us/articles/360002480678-Tool-Tabs-overview"),
    ("Workflow", "Sessions_vs_Catalogs", "https://support.captureone.com/hc/en-us/articles/30041173920029-Sessions-vs-Catalogs-in-Capture-One-how-they-work-and-where-to-store-them"),
    ("Workflow", "Backups", "https://support.captureone.com/hc/en-us/articles/27502751010333-How-Catalog-and-Session-backups-work-in-Capture-One"),
    ("Workflow", "RAW_files", "https://support.captureone.com/hc/en-us/articles/360002481998-The-way-Capture-One-works-with-RAW-files"),
    ("Layers", "AI_Masking", "https://support.captureone.com/hc/en-us/articles/14055231933853-AI-Masking"),
    ("Layers", "Magic_Brush", "https://support.captureone.com/hc/en-us/articles/4403193308049-Magic-Brush")
]

OUTPUT_DIR = "docs_raw"

def download():
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    for section, title, url in ARTICLES:
        filename = f"{section}_{title}.html"
        filepath = os.path.join(OUTPUT_DIR, filename)
        
        if os.path.exists(filepath):
            print(f"Skipping {filename}, already exists.")
            continue

        print(f"Downloading {title} from {url}...")
        # Utilisation de curl pour contourner certains blocages
        cmd = [
            "curl", "-s", "-L",
            "-H", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "-o", filepath,
            url
        ]
        
        try:
            subprocess.run(cmd, check=True)
            print(f"Saved to {filepath}")
            time.sleep(2) # Petit délai pour éviter le ban
        except Exception as e:
            print(f"Error downloading {title}: {e}")

if __name__ == "__main__":
    download()

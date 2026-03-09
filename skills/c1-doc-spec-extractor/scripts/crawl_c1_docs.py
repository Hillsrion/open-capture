import os
import requests
from bs4 import BeautifulSoup
import time
import re

ROOT_URL = "https://support.captureone.com/hc/en-us/categories/360000279017-User-guide"
BASE_URL = "https://support.captureone.com"
OUTPUT_DIR = "docs_raw"

def get_soup(url):
    print(f"Fetching {url}...")
    headers = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }
    try:
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        return BeautifulSoup(response.text, "html.parser")
    except Exception as e:
        print(f"Error fetching {url}: {e}")
        return None

def save_html(url, content, filename):
    path = os.path.join(OUTPUT_DIR, filename)
    with open(path, "w", encoding="utf-8") as f:
        f.write(f"<!-- Source: {url} -->\n")
        f.write(content)
    print(f"Saved to {path}")

def sanitize_filename(name):
    return re.sub(r'[^\w\-_\. ]', '_', name) + ".html"

def crawl():
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    soup = get_soup(ROOT_URL)
    if not soup:
        return

    # Find sections
    sections = soup.find_all("a", href=re.compile(r"/hc/en-us/sections/"))
    section_links = []
    for s in sections:
        href = s["href"]
        if not href.startswith("http"):
            href = BASE_URL + href
        section_links.append((s.text.strip(), href))

    print(f"Found {len(section_links)} sections.")

    for section_name, section_url in section_links:
        print(f"\nProcessing section: {section_name}")
        section_soup = get_soup(section_url)
        if not section_soup:
            continue

        # Find articles in section
        # Articles usually have /hc/en-us/articles/
        articles = section_soup.find_all("a", href=re.compile(r"/hc/en-us/articles/"))
        
        # Check for pagination or "See all"
        # Often articles are in a list
        processed_articles = set()
        for a in articles:
            article_url = a["href"]
            if not article_url.startswith("http"):
                article_url = BASE_URL + article_url
            
            # Avoid duplicates and anchor links
            article_url = article_url.split("#")[0]
            if article_url in processed_articles:
                continue
            processed_articles.add(article_url)

            article_title = a.text.strip()
            if not article_title:
                article_title = article_url.split("/")[-1]
            
            filename = f"{sanitize_filename(section_name)}_{sanitize_filename(article_title)}"
            
            # Check if already exists to avoid redownloading
            if os.path.exists(os.path.join(OUTPUT_DIR, filename)):
                print(f"Already exists: {filename}")
                continue

            article_soup = get_soup(article_url)
            if article_soup:
                # We save the full HTML for now as requested
                save_html(article_url, article_soup.prettify(), filename)
                time.sleep(1) # Be nice to the server

if __name__ == "__main__":
    crawl()

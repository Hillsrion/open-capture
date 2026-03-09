import os
import bs4
import re
import sys

def parse_specs(input_file, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    print(f"Parsing {input_file}...")
    with open(input_file, 'r', encoding='utf-8') as f:
        soup = bs4.BeautifulSoup(f, 'html.parser')
    
    # In Zendesk-based help centers, articles are often inside <article> or specific containers
    # We look for sections or articles
    articles = soup.find_all(['article', 'section'], class_=re.compile(r'article|section'))
    
    # If no standard containers, try to split by H1/H2
    if not articles:
        print("No standard article containers found, falling back to header-based splitting...")
        current_article = None
        article_list = []
        for element in soup.find_all(['h1', 'h2', 'p', 'ul', 'ol', 'img', 'div']):
            if element.name in ['h1', 'h2'] and 'section' not in element.get('class', []):
                if current_article:
                    article_list.append(current_article)
                current_article = {'title': element.get_text(strip=True), 'content': [str(element)]}
            elif current_article:
                current_article['content'].append(str(element))
        if current_article:
            article_list.append(current_article)
        
        for idx, art in enumerate(article_list):
            title = art['title']
            content = "\n".join(art['content'])
            save_one(title, content, output_dir, idx)
    else:
        for idx, art in enumerate(articles):
            title_elem = art.find(['h1', 'h2'])
            title = title_elem.get_text(strip=True) if title_elem else f"Article_{idx}"
            save_one(title, art.prettify(), output_dir, idx)

def save_one(title, content, output_dir, idx):
    safe_title = re.sub(r'[^\w\-_\. ]', '_', title).replace(' ', '_')
    if not safe_title or safe_title == "_":
        safe_title = f"Extracted_Article_{idx}"
    
    filename = f"Local_{safe_title}.html"
    path = os.path.join(output_dir, filename)
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(f"<html><head><meta charset='UTF-8'></head><body>{content}</body></html>")
    print(f"Saved: {filename}")

if __name__ == "__main__":
    input_p = "docs_raw/specs.html"
    output_p = "docs_raw"
    if len(sys.argv) > 1:
        input_p = sys.argv[1]
    if len(sys.argv) > 2:
        output_p = sys.argv[2]
        
    if os.path.exists(input_p):
        parse_specs(input_p, output_p)
    else:
        print(f"Error: {input_p} not found.")

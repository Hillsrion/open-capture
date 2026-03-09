import bs4
import json
import os

with open('skills/c1-doc-spec-extractor/scripts/source_tree.html', 'r') as f:
    soup = bs4.BeautifulSoup(f, 'html.parser')

base_url = "https://support.captureone.com"
articles = []
sections_to_fetch = []

sections = soup.find_all('section', class_='section')
for section in sections:
    section_title = section.find('h2').text.strip()
    
    # Check for direct articles
    article_links = section.find_all('a', class_='article-list-link')
    for a in article_links:
        articles.append({
            'section': section_title,
            'title': a.text.strip(),
            'url': base_url + a['href'] if a['href'].startswith('/') else a['href']
        })
    
    # Check for "See all"
    see_all = section.find('a', class_='see-all-articles')
    if see_all:
        sections_to_fetch.append({
            'section': section_title,
            'url': base_url + see_all['href'] if see_all['href'].startswith('/') else see_all['href']
        })

print(json.dumps({'articles': articles, 'sections_to_fetch': sections_to_fetch}, indent=2))

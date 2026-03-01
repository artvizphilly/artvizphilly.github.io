---
date: 2022-08-22T11:00:59-04:00
description: "Using SPARQL to query Wikidata for information about Black artists in Philadelphia"
featured_image: "/sparql_logo.png"
tags: [sparql]
title: "Querying Wikidata with SPARQL"
---

SPARQL is a query language for retrieving data from knowledge graphs like Wikidata. If you've used SQL to query databases, SPARQL follows a similar logic -- but instead of rows and columns, you're working with linked triples: subject, predicate, object.

For this project, we used SPARQL to pull structured data about Black artists in Philadelphia from Wikidata's public endpoint at [query.wikidata.org](https://query.wikidata.org/).

## A Basic Query

Here's a minimal query that retrieves artists tagged with the PMA's African American artist entity (Q94124522):

```sparql
SELECT ?artist ?artistLabel WHERE {
  ?artist wdt:P5008 wd:Q94124522 .
  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "en" .
  }
}
```

- `wdt:P5008` is the "on focus list of Wikimedia project" property
- `wd:Q94124522` is the PMA African American artist maintenance category
- The `SERVICE wikibase:label` block tells Wikidata to return human-readable labels instead of just Q-numbers

## Adding More Fields

The real power of SPARQL is pulling multiple properties at once. Our project queries include gender, birth/death dates, birthplace, education, occupation, employer, residence, and which museum collections hold their work. Each `OPTIONAL` clause adds a field without excluding artists who lack that data:

```sparql
OPTIONAL { ?artist wdt:P21 ?sexGender. }
OPTIONAL { ?artist wdt:P569 ?birthday. }
OPTIONAL { ?artist wdt:P19 ?birthPlace. }
OPTIONAL { ?artist wdt:P106 ?occupation. }
OPTIONAL { ?artist wdt:P6379 ?worksInCollection. }
```

## Handling Duplicates

One challenge: artists with multiple occupations or residences produce multiple rows. We handle this in SPARQL using `GROUP_CONCAT` to collapse multiple values into comma-separated strings:

```sparql
(GROUP_CONCAT(DISTINCT(?occupationLabel); separator=", ") AS ?occupations)
```

## Try It Yourself

You can run SPARQL queries directly in the browser at [query.wikidata.org](https://query.wikidata.org/). Our full query notebooks are available in the [wikidata repository](https://github.com/artvizphilly/wikidata).

For more background on SPARQL and Wikidata, see the blog posts on the [Scholars Studio site](https://sites.temple.edu/tudsc/2021/12/15/querying-wikidata/).

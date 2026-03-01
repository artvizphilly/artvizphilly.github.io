---
date: 2022-08-22T10:58:08-04:00
description: "What is Wikidata? And how can one participate in the Wikidata community"
featured_image: "/wikidata_logo.png"
tags: ["wikidata"]
title: "Wikidata"
author: "Eiman Ahmed"
---

### About ###

Wikidata is a secondary collaborative database that is curated by individuals to ultimately retrieve and store information. As of now, the database  contains nearly 100 million data items, all of which can be edited by Wikidata users, at any given time. 

### Wikidata Items ###

For instance, below is an image of the item Philadelphia Musuem of Art. As the image shows, the museum is classified as an instance of another item, the *art museum*. 

Items on Wikidata have several properties, which associate them with other items. In the example below, instance of (which is a property), connects the Philadelphia Museum of Art to other art museums.

{{<figure src="philadelphiamuseum.png">}}

Items and Properties have unique values. For instance, the Philadelphia Museum of Art has the value Q510324. Meanwhile, the value of the property, instance of, is P31. 

### Editing Items ###

Editing a Wikidata item is rather simple. First, a user must create a Wikidata account and log in. Then, they can search for the appropriate data item that they would like to edit. If a Wikidata item is available to edit (some, such as the Philadelphia Museum of Art, are protected so that only specific individuals can edit them), then users can scroll down to the bottom and click the "add statement" button (for instance). 

{{<figure src="add_statement.png">}}

Next, they can search for a property to add. For instance, users can add information on where someone is born. 

{{<figure src="place_of_birth.png">}}

Once a statement of information is added, users can publish this information immediately, for all other Wikidata users to query and retrieve.

### Batch Editing with OpenRefine

For this project, we used [OpenRefine](https://openrefine.org/) to batch-add PMA entity IDs (P8317) to Wikidata records for Black artists in the museum's collection. The process involves reconciling artist names against Wikidata, creating a schema for the new statements, and pushing the changes in bulk.

{{<figure src="/wikidata_edit_before.png" title="OpenRefine: creating a new Wikidata item">}}

{{<figure src="/wikidata_edit_after.png" title="OpenRefine: item with PMA ConstituentID statement added">}}

For a step-by-step guide to this process, see Rebecca Y. Bayeck's blog post [Editing in the World of Wikidata](https://sites.temple.edu/tudsc/2021/12/15/editing-wikidata/). Pelle Tracey's [detailed LEADING Fellowship notes](/files/leading-fellows/notes/Pelle_Tracey_LEADING_Notes.html) also walk through the full OpenRefine workflow.

### Learn More

Wikidata is a powerful resource for querying and visualizing structured data. See our other posts on [querying Wikidata with SPARQL](/post/sparql/) and [visualizing Wikidata with Python](/post/python/).

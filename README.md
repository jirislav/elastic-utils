# Sorry, this README is czech language only ..

It's about to be translated, but I haven't scheduled it yet.

# Utilitky pro manipulaci s elasticsearch
Tento adresář obsahuje komponenty pro rutinní manipulaci elasticsearch.

Skripty se pokusí o komunikaci s elasticsearch serverem specifikovaným v konfiguraci `config`

## Obsažené skripty
Každý skript má svůj help, který lze evokovat pomocí `-h`, či `--help` parametru

## Instalace skriptů elasticsearch a td-agent pro rychlou obsluhu odkudkoliv
```
# otevřete root adresář tohoto repozitáře
cd ..
# přidejte skripty do PATH bez jejich koncovek
for file in `ls -d -1 $PWD/{elasticsearch,td-agent}/*.{sh,py} 2>/dev/null | egrep -v "utilities|common|color"`; do ln -sf $file "/usr/local/bin/$(echo $file | awk 'BEGIN{FS="/"}{print $NF}' | cut -d. -f1)"; done
```

### cat API
Asi nejvíce použivanou utilitkou pro Vás bude [cat API](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat.html), sloužící k rychlému zobrazení vnitřního stavu elasticsearch instance.

Výhodou je, že si nemusíte pamatovat přesné názvy API endpointů, stačí příkaz spustit bez argumentů a vypíše Vám všechny možné argumenty, které můžete použít.
```
cat-api.sh ENDPOINT
```

### Vyhledávací skripty

#### Vyhledávání pomocí Regexp
Elasticsearch velmi omezené schopnosti, co se regulárních výrazů týče (ciz odkaz níže). Nicméně, pokud nemáte jinou možnost, pak se musíte spokojit s jeho schopnostmi. Implementace v BASHi je následující
```
./search-regexp.sh [options]

	-i | --index=INDEX			The index to search in
	-d | --document-type=DOCTYPE		The document type to search in (OPTIONAL)
	-m | --match-definition=MATCH_DEF	The document field to search within (you can specify multiple MATCH_DEFS)
	-h | --help				Shows this help message

	See standard regex operators (not much supported):
		https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-regexp-query.html#_standard_operators

	Example:
		./search-regexp.sh -i anyserver -m "log_message:.*transfermode" -m "origin_method:log[no]{2}..........."
	Explanation:
		Search the anyserver index with any document type (not specified) for matches in two fields: log_message & origin_method
			log_message has to match the ".*transfermode", while origin_method the "log[no]{2}..........." regex.

	Note that the regex is very limited & has to match any token from end to end. To learn about tokens, visit:
		https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-tokenizers.html
	
	What token basically means, is the shortest string that can be searched in an index.
```

### API pro manipulaci indexu

#### Uvolnění vyrovnávací paměti
Můžete, ale nemusíte specifikovat index, pro který se má uvolnit vyrvonávací pamět
```
cache-clear.sh INDEX_NAME
```

#### Flush indexu
Můžete, ale nemusíte specifikovat index, pro který se má provést flush - tedy zapsání změn na disk z paměti RAM, čímž dojde k jejímu částečnému uvolnění
```
index-flush.sh INDEX_NAME
```

#### Obnovení indexu
Můžete, ale nemusíte specifikovat index, který má obnovit svůj zaindexovaný obsah, aby se tak stal dostupným pro vyhledávání
```
index-refresh.sh INDEX_NAME
```

#### Zobrazení statistik komponent 
Prvním parametrem je jméno indexu, druhým (volitelným) parametrem je typ statistik, které se přejete zobrazit
```
index-stats.sh INDEX_NAME STATS_TYPE
```

#### Zobrazení nastavení indexu
Jako parametr zadáte jméno indexu k zobrazení jeho nastavení
```
index-settings.sh INDEX_NAME
```

#### Smazání indexu
Jako parametr zadáte jméno indexu ke smazání. Můžete jich zadat více jako další argumenty
```
index-remove.sh INDEX_NAME
```

#### Přejmenování indexu
Pozor, přejmenování indexu je v podstatě vytvoření jeho repliky pod jiným názvem pomocí [reindex](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-reindex.html) API, což může být náročné na výkon. Následně, pokud se reindexace zdaří, je starý index nadobro smazán!
```
index-rename.sh OLD_INDEX_NAME NEW_INDEX_NAME
```

#### Analyzátory indexu
```
index-analyze.sh INDEX_NAME ANALYZER TEXT_TO_ANALYZE

# EXAMPLE:
index-analyze.sh anyserver grid_analyzer "4a4ba08f-395d-4f4f-b98b-492b83b538c9:anyserver:161264"
```

### API pro cluster

#### Stav clusteru
```
cluster-state.sh
```

#### Statistiky clusteru
```
cluster-stats.sh
```

#### Statistiky nodů
```
cluster-nodes-stats.sh
```

#### Horké vlákna nodů
```
cluster-nodes-hot-threads.sh
```

#### Probíhající úkoly
```
cluster-penging-tasks.sh
```

#### Všechy úkoly
```
cluster-tasks-get.sh
```

#### Zrušení úkolu
```
cluster-tasks-cancel.sh TASK_ID
```

#### Aktualizace nastavení
Nastavení se definuje v adresáři `definitions` v `cluster-settings.json`
```
cluster-settings-update.sh
```


### API pro mapování

#### Vytvoření mapování typu dokumentu
Vytvoří se nový typ dokumentu pro každý index zvlášť s použitím iterativní metody nad soubory vyhovující `mapping-create-INDEX.json` v adresáři `definitions`

Takže lze takto vytvářet indexy s nadefinovanými typy dokumentů. Chcete-li pomocí této metody vytvořit další index / typ dokumentu, vytvořte proprietární `mapping-create-INDEX.json` definici.
```
mapping-create.sh
```

#### Zobrazení mapování typů dokumentů v indexu
Prvním povinným agrumentem je název indexu, druhým je dobrovolný argument specifikující požadovaný typ dokumentu
```
mapping-get.sh INDEX_NAME MAPPING_TYPE
```

### Komba volání API

#### Smaž specifikované indexy a znovu vytvoř jejich mapování (OTOČENÍ)

Tímto smažeme index `anyserver` a vytvoříme mapování pro všechny typy dokumentů definované v jednotlivých `definitions/mapping-create-INDEX_NAME.json`
```
./index-remove.sh anyserver && ./mapping-create.sh
```

## Užitečné linky

### Mapování typů dokumentů

#### Datové typy
[Field datatypes](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html#_field_datatypes)
[Multi-fields](https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-fields.html)

#### Dynamické mapování
[Dynamic mapping](https://www.elastic.co/guide/en/elasticsearch/reference/current/dynamic-mapping.html)

#### Změna datového typu
Není možná, protože by zneplatnila validaci proběhlou při indexaci. Pokud je potřeba změnit datový typ, je potřeba vytvořit nové mapování v jiném typu dokumentu či indexu a přeindexovat data tam.

#### Příklad mapování
[Example mapping](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html#_example_mapping)

### Analýza a agregace

#### Otestování tokenizátorů
Více info v [dokumentaci](https://www.elastic.co/guide/en/elasticsearch/reference/current/_explain_analyze.html)
```
http://sk8s-w05.dev:31015/_analyze?explain=true&token_filter=lowercase&tokenizer=standard&text=detaileD%20output
```

### Vyhledávání

#### Rozdíl mezi term & match
[Term Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-term-query.html)

#### Zanořený dotaz
[Terms Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-terms-query.html)

#### Dotaz s rozsahem
Větší, menší, atd .. [Range Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-range-query.html)

#### Najít dok. s chybějícím / existujícím parametrem
[Exists Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-exists-query.html)
[Missing Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-missing-query.html)

#### Regexp
[Regexp Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-regexp-query.html)

### Příklady vyhledávání

##### Dokument s prázdným polem
Hledáme v indexu `anyserver` v typu dokumentu `logs` dokument bez nastaveného pole `origin_script`
```
curl -XGET sk8s-w05.dev:31015/anyserver/logs/_search?pretty -d '
{
 "query": {
   "bool": {
     "must_not" : { "exists": { "field": "origin_script" } }
   }
 }
}'
```

##### Dokument, který nevyhovuje zadanému wildcard
Hledáme v indexu `anyserver` v typu dokumentu `logs` dokument s polem `origin_script`, které neobsahuje cokoliv vyhovující `util*py`
```
curl -XGET sk8s-w05.dev:31015/anyserver/logs/_search?pretty -d '
{
 "query": {
   "bool": {                               
     "must_not" : { "wildcard": { "origin_script": "util*py" } }               
   }
 }
}'
```

##### Dokument bez pole status, ale `log_message` status má
Použijeme hledání dokumentu s prázdným polem a zároveň wildcard pro vyhledání status v `log_message`
```
curl -XGET sk8s-w05.dev:31015/anyserver/logs/_search?pretty -d '
{
 "query": { 
   "bool": {
     "must_not" : { "exists": { "field": "status" } },
     "must" : { "wildcard" : { "log_message" : "*status*" } } }
 }
}'
```

### Příklady agregací

#### Statistiky statusů
Chceme znát všechny statusy, které logy obsahují (resp. které fluentd rozparsoval do vlastního pole pod názvem `status`)
```
curl -XGET 'sk8s-w05.dev:31015/_search?pretty' -d'
{
    "size" : 0,
    "aggs" : { 
        "statuses" : { 
            "terms" : { 
              "field" : "status"
            }
        }
    }
}'
```

Zde je odpověď, kterou jsme dostali (všimněte si, že vlastní pole `status` má celkem 454 892 497 záznamů z celkových 923 348 992 záznamů, což jsme zjistili pomocí webového prohlížeče na `http://sk8s-w05:31015/_stats?pretty` v položce _all -> total -> docs):
```
{
  "took" : 8004,
  "timed_out" : false,
  "_shards" : {
    "total" : 66,
    "successful" : 60,
    "failed" : 0
  },
  "hits" : {
    "total" : 454892497,
    "max_score" : 0.0,
    "hits" : [ ]
  },
  "aggregations" : {
    "popular_colors" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 4075,
      "buckets" : [ {
        "key" : 200,
        "doc_count" : 43005855
      }, {
        "key" : 206,
        "doc_count" : 3711573
      }, {
        "key" : 404,
        "doc_count" : 334872
      }, {
        "key" : 406,
        "doc_count" : 46342
      }, {
        "key" : 415,
        "doc_count" : 32564
      }, {
        "key" : 402,
        "doc_count" : 10140
      }, {
        "key" : 301,
        "doc_count" : 6334
      }, {
        "key" : 400,
        "doc_count" : 3759
      }, {
        "key" : 401,
        "doc_count" : 3114
      }, {
        "key" : 403,
        "doc_count" : 3096
      } ]
    }
  }
}

```

#### Průměrná doba trvání volání vzhledem k vrácenému statusu
```
curl -XGET 'sk8s-w05.dev:31015/_search?pretty' -d'
{
   "size" : 0,
   "aggs": {
      "elapsed": {
         "terms": {
            "field": "status"
         },
         "aggs": { 
            "avg_elapsed": { 
               "avg": {
                  "field": "elapsed" 
               }
            }
         }
      }
   }
}'
```

Odpoví:
```
{
  "took" : 13733,
  "timed_out" : false,
  "_shards" : {
    "total" : 66,
    "successful" : 60,
    "failed" : 0
  },
  "hits" : {
    "total" : 470690007,
    "max_score" : 0.0,
    "hits" : [ ]
  },
  "aggregations" : {
    "elapsed" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 4160,
      "buckets" : [ {
        "key" : 200,
        "doc_count" : 45348819,
        "avg_elapsed" : {
          "value" : 38.73131405278107
        }
      }, {
        "key" : 206,
        "doc_count" : 4133268,
        "avg_elapsed" : {
          "value" : 102.66254929664123
        }
      }, {
        "key" : 404,
        "doc_count" : 335460,
        "avg_elapsed" : {
          "value" : 2.7137686091964186
        }
      }, {
        "key" : 406,
        "doc_count" : 51191,
        "avg_elapsed" : {
          "value" : 2364.3977342489106
        }
      }, {
        "key" : 415,
        "doc_count" : 32564,
        "avg_elapsed" : {
          "value" : 14.718269457001165
        }
      }, {
        "key" : 402,
        "doc_count" : 10140,
        "avg_elapsed" : {
          "value" : 2.9202805492442954
        }
      }, {
        "key" : 301,
        "doc_count" : 8414,
        "avg_elapsed" : {
          "value" : 3.901023520960331
        }
      }, {
        "key" : 400,
        "doc_count" : 3759,
        "avg_elapsed" : {
          "value" : 31.60881167013187
        }
      }, {
        "key" : 403,
        "doc_count" : 3137,
        "avg_elapsed" : {
          "value" : 16.851244333781217
        }
      }, {
        "key" : 401,
        "doc_count" : 3114,
        "avg_elapsed" : {
          "value" : 4.305499999739072
        }
      } ]
    }
  }
}
```

#### K předchozímu příkladu přidány statistiky volaných metod
```
curl -XGET 'sk8s-w05.dev:31015/_search?pretty' -d'
{
   "size" : 0,
   "aggs": {
      "status": {
         "terms": {
            "field": "status"
         },
         "aggs": {
            "avg_elapsed": { 
               "avg": {
                  "field": "elapsed"
               }
            },
            "method": { 
                "terms": {
                    "field": "method" 
                }
            }
         }
      }
   }
}'
```


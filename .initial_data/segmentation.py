# -*- coding: utf-8 -*-
import nltk
from nltk.tokenize.punkt import PunktSentenceTokenizer, PunktParameters
import os
from tqdm import tqdm
import sys

nltk.download('punkt')

input_file = sys.argv[1]
output_file = sys.argv[2]

doc_seperator = "\n"
punkt_param = PunktParameters()
abbreviation = ['a', 'a.k.', 'pr', 'm', 'e', 'a.s','adv','akad','aklg','akt','al', 'angl', 'apyg','aps','apskr','asist','asmv','avd','atsak',
        'aut','biol','b.k','bkl','bot','bt','buv','chem','d','dail','dek','dėst','dir','dirig','doc','dr',
        'drp','dš','e.p','el.p','egz','eil','ekon','el', 'e', 'etc','ež','fak','faks','filol','filos','g',
        'G','gen','geol','gerb','gim','gyd','gv','įl','Įn','insp','inž','pan','t.t','istor','k','Em.','k.a','kand',
        'kat','kg','kyš','kl','kln','kn','koresp','kpt','kr','kt','kun','l.e.p', 'liet', 'ltn','mat','med', 'mėn', 'mgr','mgnt','mjr',
        'mln','mlrd','mok','mst','mstl','N','nkt','ntk','nr','p','p.d','p.m.e','pav','pavad','pirm','pl','plg',
        'plk','pr.kr','prof','prok','prot','pss','pšt','pvz','r','red','rš','s','sąs','sav','saviv','sekr',
        'sen','sk','skg','skyr','skv','sp','spec','sr','st','str','stud','š.m','šnek','šv','t','t.y','t.p','techn',
        'tel','teol','tir','tūkst','up','upl','V','vad','ved','vet','vnt','vrš','vyr','vyresn','vs','Vt','vtv', 'vv',
        'zool','žml','žr','ž.ū','šmt']
punkt_param.abbrev_types = set(abbreviation)
tokenizer = PunktSentenceTokenizer(punkt_param)

with open(input_file) as ifile:
    with open(output_file, "w") as ofile:
        for i, line in tqdm(enumerate(ifile)):
            if line != "\n":
                # sent_list = nltk.tokenize.sent_tokenize(line)
                sent_list = tokenizer.tokenize(line)
                for sent in sent_list:
                    ofile.write(sent + "\n")
                ofile.write(doc_seperator)

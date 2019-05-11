

#%%
import urllib
import requests
import json as js
import numpy as np
import pandas as pd




# repo  statistics documentation website
# https://developer.github.com/v3/repos/statistics/


# Get the weekly commit count for the repository owner and everyone else
# GET /repos/:owner/:repo/stats/participation
# Response
# Returns the total commit counts for the owner and total commit counts in all. all is everyone combined, including the owner in the last 52 weeks. If you'd like to get the commit counts for non-owners, you can subtract owner from all.
#
OAth2keysecret = '?client_id={xxxx}&client_secret={yyyy}'
OAth2keysecret = ''
token = '0ae26b10b955136a22683d4f375aa5b6f611b209'

#%%
def getCommitCount(owner, repo ):
    url ='https://edult@api.github.com/repos/{owner}/{repo}/stats/participation' 
    url = url.format(owner=owner, repo=repo)
    url = url + OAth2keysecret
    print(url)
    # response = requests.get(url= url , proxies= urllib.request.getproxies(), verify=False)
    response = requests.get(url= url)
    
    if (response.ok==False):
        raise Exception('{0}, {1}'.format(owner, repo))
    
    
    decode = js.JSONDecoder()
    responseInDict = decode.decode(response.text)
    
    totalCommitsInLast52Weeks = np.sum(responseInDict['all'])
#    print("total commits {0}".format(totalCommitsInLast52Weeks) )
    return(totalCommitsInLast52Weeks)


#%%
def getStarsForksWatchers(owner, repo):
    url ='https://edult@api.github.com/repos/{owner}/{repo}' 
    url = url.format(owner=owner, repo=repo)
    url = url + OAth2keysecret
    print(url)
    response = requests.get(url= url)
    if (response.ok==False):
        raise Exception('{0}, {1}'.format(owner, repo))
    
    temp = response.json()
    
    print("stars count:{0} forks count:{1} watchers count {2}".format(temp['stargazers_count'], 
                                temp['forks_count'],
                                temp['subscribers_count']))
    return ({'stars':temp['stargazers_count'],
             'forks':temp['forks_count'],
             'watchers':temp['subscribers_count']})
    
    
 #%%




df = pd.read_csv(r'C:\Users\erdem\Documents\code\quantMinds2019\libraryList.csv')
#df.apply(lambda x: pd.Series( , axis= 1) 
res = pd.DataFrame()
for index, row in df.iterrows():
    try:
     dict1 = {'commits':getCommitCount(row['owner'], row['repo'])}
     dict2 = getStarsForksWatchers(row['owner'], row['repo'])
     dict1.update(dict2)
     dict1.update({'owner':row['owner'], 'repo':row['repo']})
     res = res.append(dict1, ignore_index=True)
    except:
        pass
 
#%%
res.to_csv(r'C:\Users\erdem\Documents\code\quantMinds2019\gitHubStats.csv')    
     
#%%
import urllib
import requests
import json as js
import numpy as np

# url = 'https://api.github.com/repos/Microsoft/vscode/commits?since=2019-01-01T01:01:00Z'
# response = requests.get(url= url , proxies= urllib.request.getproxies(), verify=False)


# repo  statistics website
# https://developer.github.com/v3/repos/statistics/


# Get the weekly commit count for the repository owner and everyone else
# GET /repos/:owner/:repo/stats/participation
# Response
# Returns the total commit counts for the owner and total commit counts in all. all is everyone combined, including the owner in the last 52 weeks. If you'd like to get the commit counts for non-owners, you can subtract owner from all.
url ='https://api.github.com/repos/{owner}/{repo}/stats/participation' 


url = url.format(owner='tensorflow', repo='tensorflow')
# response = requests.get(url= url , proxies= urllib.request.getproxies(), verify=False)
response = requests.get(url= url)

decode = js.JSONDecoder()
responseInDict = decode.decode(response.text)

totalCommitsInLast52Weeks = np.sum(responseInDict['all'])

#!/usr/bin/python

import urllib
import re

# #################################################
# Routine to send the information to the prim
#     submitInformation(url,information)
#
def submitInformation(url,parameters) :

#    encodedParams =  urllib.urlencode(parameters);  # encode the parameters
    encodedParams  = dictionary2URI(parameters);    # encode the parameters
    net = urllib.urlopen(url,encodedParams);        # Post the data.
    return(net.read());                             # return the result.




# ################################################
# Routine to encode a dictionary without using
# "+" for spaces.
#       dictionary2URI(theDictionary)
def dictionary2URI(theDictionary) :

    encoded = '';           # Initialize the string to return
    for key, value in theDictionary.iteritems():
        # Encode each item in the dictionary.
        encoded += urllib.quote(key)+"="+urllib.quote(value)+"&";

    remove = re.compile('&$')             # Remove the trailing ampersand.
    encoded = remove.sub('',encoded);

    return(encoded);



if __name__ == "__main__":

    # Set the URL manually
    url = 'http://sim10700.agni.lindenlab.com:12046/cap/6ff4e525-b674-fc4d-aa19-478c088bf38d';

    # Define the parameters
    parameters = {'id':'244195d6-c9b7-4fd6-9229-c3a8b2e60e81',
                  'name':'M Linden',
                  'action':'send message',
                  'value':'Hey there, hi there, ho there!'};

    # Pass the information along to the prim
    info = submitInformation(url,parameters);
    print(info);

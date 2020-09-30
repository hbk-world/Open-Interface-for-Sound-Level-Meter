import requests
from requests.auth import HTTPDigestAuth

def find_sequence(sequenceId, sequences):
    """Iterations through the different sequences on the device to find the wanted one"""
    res = None
    if isinstance(sequences, dict):
        if str(sequenceId) in sequences:
            return sequences[str(sequenceId)]
        else:
            for _, subseq in sequences.items():
                if isinstance(subseq, dict):
                    res = find_sequence(sequenceId, subseq)
                if res is not None:
                    return res

def find_sequence_by_name(sequenceName, sequences):
    if isinstance(sequences, dict):
        if "Name" in sequences:
            return True if sequences["Name"] == sequenceName else False
        else:
            for count, subtree in sequences.items():
                test = find_sequence_by_name(sequenceName, subtree)
                if isinstance(test, bool) and test:
                    return int(count)
                elif isinstance(test, int) and test:
                    return test
        

def get_sequence(hostID,ID):
    """This function checks if the ID exists"""
    response = requests.get(hostID + "/webxi/sequences?recursive")
    sequences = response.json()
    sequence = find_sequence(ID, sequences)
    if sequence == None:
        raise Exception("No such sequence: " + str(ID))
    else:
        print(sequence)
        return ID, sequence


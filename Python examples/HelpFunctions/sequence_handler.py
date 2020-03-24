import requests
from requests.auth import HTTPDigestAuth

def find_sequence(sequenceId, sequences):
    """Iterations through the different sequences on the device to find the wanted one"""
    if isinstance(sequences, dict):
        if str(sequenceId) in sequences:
            return sequences[str(sequenceId)]
        else:
            for _, subseq in sequences.items():
                if isinstance(subseq, dict):
                    return find_sequence(sequenceId, subseq)

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


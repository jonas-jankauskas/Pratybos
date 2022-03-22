from datetime import datetime

#-----------------------------------------------
def make_subs(old_text, changes):
    '''
        Performs substitutions in old_text string specified in the dicrtionary changes
    '''
    new_text = str(old_text)
    for s in changes.keys():
            new_text = new_text.replace(s, changes[s])
    return new_text

#-----------------------------------------------
def write_file(file_name, text):
    '''
        Overwrites the text into a file
    '''
    outf = open(file_name, 'w')
    outf.write(text)
    outf.close()

#-----------------------------------------------
def get_date_time():
    '''
        Returns pre-formated current date-time string
    '''
    now = datetime.now()
    time_stamp = now.strftime("%Y/%m/%d %H:%M:%S")
    return time_stamp
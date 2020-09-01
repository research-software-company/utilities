import csv
import argparse
from iteration_utilities import unique_everseen
data={}

def get_worked_days_count():

    #------------------read the csv file (from parameters) without the headers -----------------
    parser = argparse.ArgumentParser()
    parser.add_argument('input_csv_file')
    parser.add_argument('output_csv_file')
    args = parser.parse_args()
    with open(args.input_csv_file,encoding="utf-8-sig") as input_file:
        # next(input_file,None)
        # next(input_file,None)
        reader = csv.DictReader(input_file)

    #------------------iterate the csv file to get for each user all the days he worked-----------------
        user_dates_pairs=[] 
        users=[]
        for rows in reader:
            user=rows['User']
            users.append(user)
            date=rows['Start date']
            date_per_user={"user":user,"date":date}
            user_dates_pairs.append(date_per_user) # user_dates_pair is a list of dictionary , each dict contains a pair with a name and a day of work

    #------------------remove duplicate worked days for each person-----------------
        user_dates_pairs=list(unique_everseen(user_dates_pairs))
        users=list(filter(None ,unique_everseen(users)))

    #------------------go over the list user_dates_pair and count the worked days according to each user-----------------
        countdays_per_user =[]
        worked_dates_per_user=[]
        for user in users:
            for pair in user_dates_pairs:
                if pair['user'] == user:
                    worked_dates_per_user.append(pair['date'])
                count_per_user={"User":user,"Number of Worked Days":len(worked_dates_per_user)}
            countdays_per_user.append(count_per_user)
            worked_dates_per_user=[]

    #------------------return the data in csv format into the output file from the parameters-----------------
        toCSV=countdays_per_user
        keys=toCSV[0].keys()
        with open(args.output_csv_file,'w') as output_file:
            dict_writer = csv.DictWriter(output_file, keys)
            dict_writer.writeheader()
            dict_writer.writerows(toCSV)
if __name__ == '__main__':
    get_worked_days_count()

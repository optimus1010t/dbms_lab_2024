import psycopg2
from prettytable import PrettyTable

if __name__ == "__main__":
    try:
        # Connecting to my postgres DB
        conn = psycopg2.connect(
            dbname="21CS30054",         # Database name
            user="21CS30054",           # user id
            password="21CS30054",       # password
            host="10.5.18.71"           # host
        )

        # Open a cursor to perform database operations
        cur = conn.cursor()        
        # Execute a query
        while True:
            # print all the queries
            print("1. Roll number and name of all the students who are managing the “Megaevent”")
            print("2. Roll number and name of all the students who are managing “Megevent ” as a “Secretary”.")
            print("3. Name of all the participants from the college “IITB” in “Megaevent”.")
            print("4. Name of all the colleges who have at least one participant in “Megaevent”.")
            print("5. Name of all the events which are managed by a “Secretary”.")
            print("6. Name of all the “CSE” department student volunteers of “Megaevent ”.")
            print("7. Name of all the events which have at least one volunteer from “CSE” department.")
            print("8. Name of the college with the largest number of participants in “Megaevent”.")
            print("9. Name of the college with the largest number of participants overall.")
            print("10. Name of the department with the largest number of volunteers in all the events which has at least one participant from “IITB”.")
            print("11. Roll number and name of all the students who are managing the inputted event.")
            print("12. Exit")           # exit option
            # ask for the query number
            query = int(input("Enter the query number: "))      # input the query number
            if query == 1:
                # Execute first query
                cur.execute("SELECT S.Roll, S.Name FROM Student S JOIN MANAGE M ON S.Roll = M.Student_Roll JOIN Event E ON M.EID = E.EID WHERE E.EName = 'Megaevent';")
                # print the query
                print("Roll number and name of all the students who are managing the “Megaevent” : ")
            elif query == 2:
                # Execute second query
                cur.execute("SELECT S.Roll, S.Name FROM Student S JOIN Role R ON S.Roll = R.Student_Roll JOIN MANAGE M ON S.Roll = M.Student_Roll JOIN Event E ON M.EID = E.EID WHERE E.EName = 'Megaevent' AND R.Rname = 'Secretary';")
                # print the query
                print("Roll number and name of all the students who are managing “Megevent ” as a “Secretary” : ")
            elif query == 3:
                # Execute third query
                cur.execute("SELECT P.name FROM Participant P JOIN College C ON P.college_name = C.name JOIN Event_Participant EP ON P.pid = EP.pid JOIN Event E ON EP.eid = E.eid WHERE C.name = 'IITB' AND E.ename = 'Megaevent';")
                # print the query
                print("Name of all the participants from the college “IITB” in “Megaevent” : ")
            elif query == 4:
                # Execute fourth query
                cur.execute("SELECT DISTINCT C.name FROM College C JOIN Participant P ON C.name = P.college_name JOIN Event_Participant EP ON P.pid = EP.pid JOIN Event E ON EP.eid = E.eid WHERE E.ename = 'Megaevent';")
                # print the query
                print("Name of all the colleges who have at least one participant in “Megaevent” : ")
            elif query == 5:
                # Execute fifth query
                cur.execute("SELECT DISTINCT E.ename FROM Event E JOIN Manage M ON E.eid = M.eid JOIN Student S ON M.student_roll = S.roll JOIN Role R ON S.roll = R.student_roll WHERE R.rname = 'Secretary';")
                # print the query
                print("Name of all the events which are managed by a “Secretary” : ")
            elif query == 6:
                # Execute sixth query
                cur.execute("SELECT S.name FROM Student S JOIN Volunteer V ON S.roll = V.roll JOIN Event_Volunteer EV ON V.roll = EV.volunteer_roll JOIN Event E ON EV.eid = E.eid WHERE S.dept = 'CSE' AND E.ename = 'Megaevent';")                
                # print the query
                print("Name of all the “CSE” department student volunteers of “Megaevent ” : ")
            elif query == 7:
                # Execute seventh query
                cur.execute("SELECT DISTINCT E.ename FROM Event E JOIN Event_Volunteer EV ON E.eid = EV.eid JOIN Volunteer V ON EV.volunteer_roll = V.roll JOIN Student S ON V.roll = S.roll WHERE S.dept = 'CSE';")
                # print the query
                print("Name of all the events which have at least one volunteer from “CSE” department : ")
            elif query == 8:
                # Execute eighth query
                cur.execute("SELECT C.name FROM College C JOIN Participant P ON C.name = P.college_name JOIN Event_Participant EP ON P.pid = EP.pid JOIN Event E ON EP.eid = E.eid WHERE E.ename = 'Megaevent' GROUP BY C.name ORDER BY COUNT(P.pid) DESC LIMIT 1;")
                # print the query
                print("Name of the college with the largest number of participants in “Megaevent” : ")
            elif query == 9:
                # Execute ninth query
                cur.execute("SELECT C.name FROM College C JOIN Participant P ON C.name = P.college_name GROUP BY C.name ORDER BY COUNT(P.pid) DESC LIMIT 1;")
                # print the query
                print("Name of the college with the largest number of participants overall : ")
            elif query == 10:
                # Execute tenth query
                cur.execute("SELECT S.dept, COUNT(DISTINCT V.roll) as volunteer_count FROM student S JOIN volunteer V ON S.roll = V.roll JOIN event_volunteer EV ON V.roll = EV.volunteer_roll JOIN event E ON EV.eid = E.eid JOIN event_participant EP ON E.eid = EP.eid JOIN participant P ON EP.pid = P.pid WHERE P.college_name = 'IITB' GROUP BY S.dept ORDER BY COUNT(DISTINCT V.roll) DESC LIMIT 1;")
                # print the query
                print("Name of the department with the largest number of volunteers in all the events which has at least one participant from “IITB” : ")
            elif query == 11:
                # Execute the eleventh query
                event = input("Enter the name of the event: ")      # input the event name
                cur.execute(f"SELECT S.Roll, S.Name FROM Student S JOIN MANAGE M ON S.Roll = M.Student_Roll JOIN Event E ON M.EID = E.EID WHERE E.EName = '{event}';") # passing the event name as part of the string
                # print the query
                print(f"Roll number and name of all the students who are managing \"{event}\" : ")
            elif query == 12:
                # Exit the program
                print("Exiting...")
                break
            else:
                print("Invalid query number, try again.")   # if the query number is invalid
                continue
            # Retrieve query results
            records = cur.fetchall()
            # printing the records in a better fashion
            if records:
                columns = [desc[0] for desc in cur.description] # getting the column names
                table = PrettyTable(columns)                    # creating a pretty table
                table.add_rows(records)                         # adding the records to the table
                print(table)                                    # printing the table
            else:
                print("No records found.")                      # if no records are found
            
        # Clean up
        cur.close()                 # close the cursor
        conn.close()                # close the connection

    except Exception as e:
        print(f"An error occurred: {e}")    # print the error message
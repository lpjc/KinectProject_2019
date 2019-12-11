# KinectProject_2019
5th semester project for RUC.

1) Open VideoReceiver_pde on the machine u need to have as destination

2) Open VideoSender on the machine connected to a kinect. (max one kinect per machine)

3) In the VideoSender(s) - modify the port to be unique for each machine(and pref +9000)
  3a) in the VideoReceiver_pde - replace the 9100 and 9200 in line 11 with the port you've chosen (you can also add more):  <html><body><pre>
&nbsp;&nbsp;<span style="color: #E2661A;">int</span>[] ports = {9100, 9200}; <span style="color: #666666;">// ADD PORTS HERE - ADD ONLY THE ONES THAT ARE USED </span>
</pre></body></html>

4) In the VideoSender(s), replace the IP at line 88 with the host IP of the receiving machine
    TIP!: on windows, go to commandpromt on the receivering machine and write <html><body><pre> ipconfig </pre></body></html> to find the IP of the machine.
    
5) Run the applications, the VideoSender(s) might need to be rebooted once for the Kinect to establish connection.



Questions? write me
@LPJC on github or lpjc(at)ruc.dk

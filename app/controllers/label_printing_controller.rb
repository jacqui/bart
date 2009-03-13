class LabelPrintingController < ApplicationController
  def print_drug_dispensed
    patient=Patient.find(session[:patient_id])
    date = (session[:encounter_datetime]).to_date
    string_label=patient.drug_dispensed_label(date)

    send_data(string_label, :type=> "application/label; charset=utf-8", :stream=> false, :filename=>"#{patient.id}#{rand(10000)}.lbl", :disposition => 'inline')
  end


  def print_user_label
     user=  User.find(session[:user_edit])
     user_name=user.username
     user_real_name=user.name
     user_role = user.roles.first.role
     
  string_label=<<EOF
""
N
q776
Q329,026
A40,30,0,2,2,2,N,"#{user_real_name.delete("'")}"
A40,80,0,2,2,2,N,"#{user_role}"
B40,130,0,1,5,15,120,B,"#{user_name}"
P1
N\\f

EOF

      send_data(string_label,:type=>"application/label; charset=utf-8", :stream=> false, :filename=>"#{user.id}#{rand(10000)}.lbl", :disposition => "inline")
  end

  
  def print_drug_label

     drug = DrugBarcode.find_by_barcode(params[:id])
     drug_name=drug.drug.name
     drug_name1=""
     drug_name2=""
     drug_quantity=drug.quantity
     drug_barcode = drug.barcode
     drug_string_length =drug_name.length
     
     if drug_name.length > 27
        drug_name1=drug_name.match(/(.*) ([A-Z].*)/)[1]        
        drug_name2=drug_name.match(/(.*) ([A-Z].*)/)[2]
     end  

     if drug_string_length <= 27 
       label = ZebraPrinter::StandardLabel.new
       label.draw_barcode(40, 130, 0, 1, 5, 15, 120,false, "#{drug_barcode}")
       label.draw_text("#{drug_name}", 40, 30, 0, 2, 2, 2, false)
       label.draw_text("Quantity: #{drug_quantity}", 40, 80, 0, 2, 2, 2,false)
     else  
       label = ZebraPrinter::StandardLabel.new
       label.draw_text("#{drug_name1}", 40, 30, 0, 2, 2, 2, false)
       label.draw_text("#{drug_name2}", 40, 80, 0, 2, 2, 2, false)
       label.draw_text("Quantity: #{drug_quantity}", 40, 130, 0, 2, 2, 2,false)
       label.draw_barcode(40, 180, 0, 1, 5, 15, 120,false, "#{drug_barcode}")
     end

      send_data(label.print(1),:type=>"application/label; charset=utf-8", :stream=> false, :filename=>"#{drug_barcode}.lbl", :disposition => "inline")
  end  

  def visit_label
    patient=Patient.find(session[:patient_id])
    date = (session[:encounter_datetime]).to_date
    encounters = patient.encounters.find_by_date(date)
    string_label = ZebraPrinter::VisitLabel.from_encounters(encounters)
    send_data(string_label, :type=> "application/label; charset=utf-8", :stream=> false, :filename=>"#{patient.id}#{rand(10000)}.lbl", :disposition => 'inline')
   
  end
end

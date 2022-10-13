//
//  EmployeeTableViewCell.swift
//  EmpBook
//
//  Created by A118830248 on 11/10/22.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var employee: Employee? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI() {
        let urlString = employee?.photo ?? ""
        if let url = URL(string: urlString) {
            profileImageView.download(from: url, placeholder: UIImage(named: "user"))
        }
        nameLabel.text = "Name: \(employee?.fullName ?? "")"
        salaryLabel.text = "Salary: ₹.\(employee?.salary ?? "")"
        dateLabel.text = "Joined on: \(employee?.hireDate ?? "")"
        addressLabel.text = "Address: \(employee?.address ?? "")"
    }
}

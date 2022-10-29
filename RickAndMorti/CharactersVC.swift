//
//  ViewController.swift
//  RickAndMorti
//
//  Created by Hasan Hasanov on 27.10.22.
//

import UIKit

class CharactersVC: BaseVC {
    
    var filterData = FilterData.filterOptions
    var selectedTextfieldFilter = 0
    var selectedOptionsFilter: Int? = nil
    var vm = CharactersVM()
    var charactersData: CharactersResponse?
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var filterTextField: UITextField!{
        didSet{
            filterTextField.delegate = self
        }
    }
    @IBOutlet weak var  filterCollectionView: UICollectionView!{
        didSet{
            filterCollectionView.delegate = self
            filterCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var charactersTableView: UITableView!{
        didSet{
            charactersTableView.delegate = self
            charactersTableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    var dropdownHeight: NSLayoutConstraint?
    var dropdownWidth: NSLayoutConstraint?
    var dropdownCenter: NSLayoutConstraint?
    var dropdownTop: NSLayoutConstraint?
    lazy var dropDownTableView: UITableView = {
       let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(OptionsTableViewCell.self, forCellReuseIdentifier: "OptionsTableViewCell")
        view.estimatedRowHeight = 0
        view.estimatedSectionFooterHeight = 0
        view.estimatedSectionHeaderHeight = 0
        view.cornerradius = 10
        view.bounces = false
        return view
    }()

    func setupView(){
        setBindings()
        setupTableView()
        getData()
        
        
    }
    
    func setupTableView(){
        view.addSubview(dropDownTableView)
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        charactersTableView.addSubview(refreshControl)
    }
    func getData(){
        let text = filterTextField.text
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {return}
            self.vm.getCharacters(filterData: self.filterData, text: text)
        }
    }
    func setBindings(){
        vm.successOnGetCharacters = { [weak self] nextPage, data in
            guard let self = self else {return}
            if nextPage{
                let oldResults = self.charactersData?.results
                self.charactersData?.results = (oldResults ?? []) + (data?.results ?? [])
            }else{
                self.charactersData = data
            }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.charactersTableView.reloadData()
            }
            
            
        }
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.vm.getCharacters(filterData: self.filterData, text: filterTextField.text)
    }
}

extension CharactersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCVCell", for: indexPath) as! FilterCVCell
        if filterData[indexPath.row].type == .texfield{
            cell.setup(titleName: filterData[indexPath.row].title, hasDropDown: filterData[indexPath.row].options != nil, isSelected: selectedTextfieldFilter == indexPath.row)
        }else{
            cell.setup(isOpen: selectedOptionsFilter == indexPath.row, titleName: filterData[indexPath.row].options?[filterData[indexPath.row].selectedOptionIndex], hasDropDown: filterData[indexPath.row].options != nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filterData[indexPath.row].type == .texfield{
            let oldIndex = selectedTextfieldFilter
            selectedTextfieldFilter = indexPath.row
            filterData[selectedTextfieldFilter].selectedTextField = true
            filterData[oldIndex].selectedTextField = false
            collectionView.reloadItems(at: [IndexPath(row: selectedTextfieldFilter, section: 0), IndexPath(row: oldIndex, section: 0)])
            filterTextField.placeholder = "Search by \(filterData[indexPath.row].title)..."
        }else{
            let oldIndex = selectedOptionsFilter
            if selectedOptionsFilter == indexPath.row{
                selectedOptionsFilter = nil
            }else{
                selectedOptionsFilter = indexPath.row
            }
            if let oldIndex{
                collectionView.reloadItems(at: [IndexPath(row: oldIndex, section: 0)])
            }
            if let selectedOptionsFilter{
                collectionView.reloadItems(at: [IndexPath(row: selectedOptionsFilter, section: 0)])
            }
            if let dropdownWidth, let dropdownHeight, let dropdownCenter, let dropdownTop{
                NSLayoutConstraint.deactivate([
                    dropdownTop,
                    dropdownWidth,
                    dropdownCenter,
                    dropdownHeight,
                ])
            }
            if let cell = collectionView.cellForItem(at: indexPath){
                dropDownTableView.reloadData()
                dropdownTop = dropDownTableView.topAnchor.constraint(equalTo: cell.bottomAnchor, constant: 5)
                dropdownWidth = dropDownTableView.widthAnchor.constraint(equalTo: cell.widthAnchor)
                dropdownHeight = dropDownTableView.heightAnchor.constraint(equalToConstant: dropDownTableView.contentSize.height)
                dropdownCenter = dropDownTableView.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                NSLayoutConstraint.activate([
                    dropdownTop!,
                    dropdownWidth!,
                    dropdownHeight!,
                    dropdownCenter!,
                ])
                view.layoutSubviews()
            }
            
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if filterData[indexPath.row].type == .texfield{
            let textSize = filterData[indexPath.row].title.getSize(with: [.font: UIFont.systemFont(ofSize: 17)])
            return vm.calculateCellSize(textSize: textSize, hasIcon: filterData[indexPath.row].options != nil)
        }else{
            let data = filterData[indexPath.row].options
            let index = filterData[indexPath.row].selectedOptionIndex
            let textSize = data?[index].getSize(with: [.font: UIFont.systemFont(ofSize: 17)]) ?? CGSize(width: 0, height: 0)
            return vm.calculateCellSize(textSize: textSize, hasIcon: filterData[indexPath.row].options != nil)
        }
        
    }
    
}
extension CharactersVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case dropDownTableView:
            return filterData[safe: selectedOptionsFilter ?? -1]?.options?.count ?? 0
        case charactersTableView:
            return charactersData?.results?.count ?? 0
        default:
            fatalError("Add new tableView to \(#function) in \(self.description)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case dropDownTableView:
            let cell = dropDownTableView.dequeueReusableCell(withIdentifier: "OptionsTableViewCell") as! OptionsTableViewCell
            
            cell.setup(text: filterData[safe: selectedOptionsFilter ?? -1]?.options?[indexPath.row])
            return cell
        case charactersTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharactersCell") as! CharactersCell
            cell.setup(character: charactersData?.results?[indexPath.row])
            return cell
        default:
            fatalError("Add new tableView to \(#function) in \(self.description)")
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (charactersData?.results?.count ?? 0) - 1{
            vm.getNextPage()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView{
        case dropDownTableView:
            
            if let selectedOptionsFilter{
                filterData[selectedOptionsFilter].selectedOptionIndex = indexPath.row
                filterCollectionView.reloadItems(at: [IndexPath(row: selectedOptionsFilter, section: 0)])
                vm.getCharacters(filterData: filterData, text: filterTextField.text)
            }
        case charactersTableView:
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "CharacterDetailVC") as! CharacterDetailVC
            vc.character = charactersData?.results?[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        default:
            
            break
        }
    }
    
}
extension CharactersVC: UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        vm.getCharacters(filterData: filterData, text: textField.text)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

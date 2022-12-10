import Foundation

class SearchTableViewModel {
    
    var reloadHandler: (() -> Void)?
    
    var sectionModels: [SearchTableViewSectionModel] {
        didSet {
            reloadHandler?()
        }
    }
    
    var currentSectionModels: [SearchTableViewSectionModel] {
        didSet {
            reloadHandler?()
        }
    }

    var sectionsCount: Int {
        return currentSectionModels.count
    }
    
    var firstNonEmptySection: Int? {
        return currentSectionModels.firstIndex(where: { !$0.events.isEmpty })
    }
    
    init(sectionModels: [SearchTableViewSectionModel]) {
        self.sectionModels = sectionModels
        self.currentSectionModels = sectionModels
    }
    
    func numberOfRows(in section: Int) -> Int {
        return sectionModels[section].isOpen ? currentSectionModels[section].events.count : 0
    }
    
    func cellModel(for indexPath: IndexPath) -> EventModel {
        return currentSectionModels[indexPath.section].events[indexPath.row]
    }
    
    func openClose(section: Int) {
        sectionModels[section].isOpen = !sectionModels[section].isOpen 
    }
    
    func openAll() {
        sectionModels.enumerated().compactMap { $0.element.events.isEmpty ? nil : $0.offset }.forEach({ sectionModels[$0].isOpen = true })
    }
    
    func closeAll() {
        sectionModels.enumerated().forEach({ sectionModels[$0.offset].isOpen = ($0.offset == 0) })
    }
    
    func filterCurrentSectionModels(by searchText: String) {
        currentSectionModels = sectionModels.map { model in
            let cellModels = model.events.filter {
                $0.homeTitle.hasPrefix(searchText) ||  $0.awayTitle.hasPrefix(searchText) || $0.dateString.hasPrefix(searchText)
            }
            return SearchTableViewSectionModel(title: model.title, events: cellModels)
        }
    }
}

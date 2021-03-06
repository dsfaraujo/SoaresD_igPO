//=================================
import UIKit
//=================================
//Classe Controlle de la page CSV
class CSVController: UIViewController
{
    @IBOutlet weak var cvsTextView: UITextView!
    /* ---------------------------------------*/
    var jsonManager = JsonManager(urlToJsonFile: "http://www.igweb.tv/ig_po/json/data.json")
    var listOfSelectedPrograms: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var listOfMedias: [Int] = [0, 0, 0, 0, 0, 0, 0, 0]
    /* ---------------------------------------*/
    //Fonction que demarre la vue CSV
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.jsonManager.importJSON()
        self.cvsTextView.text = self.jsonManager.converJsonToCsv("NOM,TÉLÉPHONE,COURRIEL,COMMENT,PROGRAMMES")
        motDePasseField.isSecureTextEntry = true

    }
    /* ---------------------------------------*/
     override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    /* ---------------------------------------*/
    //fonction que filtre les données montrées dans la page
    @IBAction func buttonsForFiltering(_ sender: UIButton)
    {
        var strToDisplay = ""
        
        switch sender.currentTitle!
        {
            case "NOMS" :
                strToDisplay = "Noms :\n"
                for (a, _) in self.jsonManager.jsonParsed
                {
                    strToDisplay += "\t. \(a)\n"
                }
                
                self.cvsTextView.text = strToDisplay
                
            case "TÉLÉPHONES" : self.cvsTextView.text = self.jsonManager.filter(0, title: "Téléphones")
            case "COURRIELS" : self.cvsTextView.text = self.jsonManager.filter(1, title: "Courriels")
            case "MÉDIAS" : self.mostEfficientMedia()
            case "PARTICIPANTS" : self.cvsTextView.text = "PARTICIPANTS :\n\t\(self.jsonManager.jsonParsed.count) participants inscrits aux portes ouvertes."
                
            default : print("Not found...")
        }
    }
    /* ---------------------------------------*/
    //fonction que filtre les données montrées dans la page avec les programmes selectionnées
    @IBAction func programInterests(_ sender: UIButton)
    {
        self.listOfSelectedPrograms = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

        //liste de programmes
        let arrProgramNames: [String] = [
            "DEC - Techniques de production et postproduction télévisuelles (574.AB)",
            "AEC - Production télévisuelle et cinématographique (NWY.15)",
            "AEC - Techniques de montage et d’habillage infographique (NWY.00)",
            "DEC - Techniques d’animation 3D et synthèse d’images (574.BO)",
            "AEC - Production 3D pour jeux vidéo (NTL.12)",
            "AEC - Animation 3D et effets spéciaux (NTL.06)",
            "DEC - Techniques de l’informatique, programmation nouveaux médias (420.AO)",
            "DEC - Technique de l’estimation en bâtiment (221.DA)",
            "DEC - Techniques de l’évaluation en bâtiment (221.DB)",
            "AEC - Techniques d’inspection en bâtiment (EEC.13)",
            "AEC - Métré pour l’estimation en construction (EEC.00)",
            "AEC - Sécurité industrielle et commerciale (LCA.5Q)"]
        //prendre les données dans json
        for index in 0 ..< arrProgramNames.count
        {
            let s = ". \(arrProgramNames[index])"

            for (_, b) in self.jsonManager.jsonParsed
            {
                if s == (b as AnyObject).objectAt(3) as! String
                {
                    self.listOfSelectedPrograms[index] += 1
                }
            }
        }
        
        var s: String = "INTÉRÊT DES PROGRAMMES : \n\n"
        
        for index in 0 ..< arrProgramNames.count
        {
            s += "\t. \(self.listOfSelectedPrograms[index]) = \(arrProgramNames[index])\n"
        }
        
        self.cvsTextView.text = s
    }
    /* ---------------------------------------*/
    //fonction que filtre les données montrées dans la page pour les médias le plus efficientes
    func mostEfficientMedia()
    {
        self.listOfMedias = [0, 0, 0, 0, 0, 0, 0, 0]
        
        let arrMedias: [String] = [
            "Amis / Famille",
            "Radio",
            "Publicité Internet",
            "Journaux",
            "Moteur de recherche",
            "Médias sociaux",
            "Télévision",
            "Autres"]
        
        for index in 0 ..< arrMedias.count
        {
            let s = "\(arrMedias[index])"
            
            for (_, b) in self.jsonManager.jsonParsed
            {
                if s == (b as AnyObject).objectAt(2) as! String
                {
                    self.listOfMedias[index] += 1
                }
            }
        }
        
        var s: String = "EFFICACITÉ DES MÉDIAS : \n\n"
        
        for index in 0 ..< arrMedias.count
        {
            s += "\t. \(self.listOfMedias[index]) = \(arrMedias[index])\n"
        }
        
        self.cvsTextView.text = s
    }
    /* ---------------------------------------*/
    @IBOutlet weak var ViewMotDePasse: UIView!
    /* ---------------------------------------*/
    //fonction que reset les données dans la page
    @IBAction func reset(_ sender: UIButton)
    {
        
        let refreshAlert = UIAlertController(title: "Réinialisation", message: "Vous voulez vraiment tout réinitialiser?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
            self.ViewMotDePasse.frame.origin.x = (UIScreen.main.bounds.width - 400)/2
            }))
        
        refreshAlert.addAction(UIAlertAction(title: "Non", style: .default, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    /* ---------------------------------------*/
    //Fonction pour initializer les données dans JSON et PHP
    func reallyDoReset()
    {
        self.jsonManager.upload("delete=reset", urlForAdding: "http://www.igweb.tv/ig_po/php/delete.php")
        self.cvsTextView.text = ""
        self.jsonManager = JsonManager(urlToJsonFile: "http://www.igweb.tv/ig_po/json/data.json")
    }
    /* ---------------------------------------*/
    var defaults = UserDefaults.standard
    /* ---------------------------------------*/
    @IBOutlet weak var utilisateurLabel: UILabel!
    @IBOutlet weak var utilisateurField: UITextField!
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var motDePasseField: UITextField!
    /* ---------------------------------------*/
    //Fonction que demande la mot de passe d'administrateur pour reinitializer les informations de la page CSV
    @IBAction func motDePasseButton(_ sender: UIButton) {
        if defaults.object(forKey: "PASSWORD") == nil {
            defaults.set(motDePasseField.text, forKey: "PASSWORD")
            defaults.set(utilisateurField.text, forKey: "USER")
            setLabelButton()
        }
        else{
            utilisateurAdmin = defaults.object(forKey: "USER") as! String
            motDePasseAdmin = defaults.object(forKey: "PASSWORD") as! String
            
            if utilisateurAdmin == utilisateurField.text! && motDePasseAdmin == motDePasseField.text!{
                self.reallyDoReset()
                self.ViewMotDePasse.frame.origin.x = -800
            }
            else{
                let alertController = UIAlertController(title: "Mot de passe ou utilisateur incorrect", message:"Réessayez", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Abandonner", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    /* ---------------------------------------*/
    //fonction que set le title dans la page de view mot de passe
    private func setLabelButton(){
        if defaults.object(forKey: "PASSWORD") == nil{
            aLabel.text = "Créez une mot de passe"
            utilisateurLabel.text = "Créez un nom d'utilisateur"
            
        }
        else{
            utilisateurLabel.text = "Nom d'utilisateur"
            aLabel.text = "Mot de passe"
            motDePasseField.text = ""
            utilisateurField.text = ""
            
        }
    }
    /* ---------------------------------------*/
    @IBOutlet weak var viewInfo: UIView!
    //button qui apelle la view d'info
    @IBAction func buttonInfo(_ sender: UIButton) {
        viewInfo.frame.origin.x = (UIScreen.main.bounds.width - 400)/2
    
    }
    /* ---------------------------------------*/
    //button que sort de la view info
    @IBAction func buttonSortieInfo(_ sender: UIButton) {
        viewInfo.frame.origin.x = -800
    }
    /* ---------------------------------------*/
    //button que sort de la view mot de passe
    @IBAction func sortieMotPasse(_ sender: UIButton) {
        ViewMotDePasse.frame.origin.x = -800
    }
}
//=================================









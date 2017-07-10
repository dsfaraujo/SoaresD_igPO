//=================================
import UIKit
//=================================
class ViewController: UIViewController
{
    /* ---------------------------------------*/
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var amis: UIButton!
    @IBOutlet weak var radio: UIButton!
    @IBOutlet weak var pub_internet: UIButton!
    @IBOutlet weak var journaux: UIButton!
    @IBOutlet weak var moteur: UIButton!
    @IBOutlet weak var sociaux: UIButton!
    @IBOutlet weak var tv: UIButton!
    @IBOutlet weak var autres: UIButton!
    /* ---------------------------------------*/
    var pickerChoice: String = ""
    var arrMediaButtons:[UIButton]!
    /* ---------------------------------------*/
    var arrForButtonManagement: [Bool] = []
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
    //let jsonManager = JsonManager(urlToJsonFile: "http://localhost/xampp/geneau/ig_po/json/data.json")
    let jsonManager = JsonManager(urlToJsonFile: "http://www.igweb.tv/ig_po/json/data.json")
    /* ---------------------------------------*/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrMediaButtons = [amis, radio, pub_internet, journaux, moteur, sociaux, tv, autres]
        
        jsonManager.importJSON()
        
        fillUpArray()
        
         motDePasseField.isSecureTextEntry = true
    }
    /* ---------------------------------------*/
    func fillUpArray()
    {
        for _ in 0...11
        {
            arrForButtonManagement.append(false)
        }
    }
    @IBOutlet var ViewMotDePasse: UIView!
    /* ---------------------------------------*/
    @IBAction func logoButton(_ sender: UIButton) {
        ViewMotDePasse.frame.origin.x = (UIScreen.main.bounds.width - 400)/2
    }
    
    var defaults = UserDefaults.standard
    var motDePasseAdmin: String!
    var utilisateurAdmin: String!

    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var motDePasseField: UITextField!
    @IBOutlet weak var utilisateurLabel: UILabel!
    @IBOutlet weak var utilisateurField: UITextField!
    
    @IBAction func motDePasseButton(_ sender: UIButton) {
        if defaults.object(forKey: "PASSWORD") == nil {
            defaults.set(motDePasseField.text, forKey: "PASSWORD")
            defaults.set(utilisateurField.text, forKey: "USER")
            setLabelButton()
        }
        else{
            utilisateurAdmin = defaults.object(forKey: "USER") as! String
            motDePasseAdmin = defaults.object(forKey: "PASSWORD") as! String

print(utilisateurAdmin)
print(motDePasseAdmin)

            if utilisateurAdmin == utilisateurField.text! && motDePasseAdmin == motDePasseField.text!{
                performSegue(withIdentifier: "seg", sender: nil)
                
            }
            else{
                let alertController = UIAlertController(title: "Mot de passe ou utilisateur incorrect", message:"Réessayez", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Abandonner", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }

    }
    /* ---------------------------------------*/

    
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
    func manageSelectedPrograms() -> String
    {
        var stringToReturn: String = ". "
        
        for x in 0 ..< arrProgramNames.count
        {
            if arrForButtonManagement[x]
            {
                stringToReturn += arrProgramNames[x] + "\n. "
            }
        }
        
        // Delete 3 last characters of string...
        if stringToReturn != ""
        {
            stringToReturn = stringToReturn.substring(to: stringToReturn.characters.index(before: stringToReturn.endIndex))
            stringToReturn = stringToReturn.substring(to: stringToReturn.characters.index(before: stringToReturn.endIndex))
            stringToReturn = stringToReturn.substring(to: stringToReturn.characters.index(before: stringToReturn.endIndex))
        }
        
        return stringToReturn
    }
    /* ---------------------------------------*/
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    /* ---------------------------------------*/
    @IBAction func buttonManager(_ sender: UIButton)
    {
        let buttonIndexInArray = sender.tag - 100
        
        if !arrForButtonManagement[buttonIndexInArray]
        {
            sender.setImage(UIImage(named: "case_select.png"), for: UIControlState())
            arrForButtonManagement[buttonIndexInArray] = true
        }
        else
        {
            sender.setImage(UIImage(named: "case.png"), for: UIControlState())
            arrForButtonManagement[buttonIndexInArray] = false
        }
    }
    /* ---------------------------------------*/
    func deselectAllButtons()
    {
        for x in 0 ..< arrForButtonManagement.count
        {
            arrForButtonManagement[x] = false
            let aButton: UIButton = (view.viewWithTag(100 + x) as? UIButton)!
            aButton.setImage(UIImage(named: "case.png"), for: UIControlState())
        }
    }
    /* ---------------------------------------*/
    @IBAction func saveInformation(_ sender: UIButton)
    {
        if name.text == "" || phone.text == "" || email.text == ""
        {
            alert("Veuillez ne pas laisser aucun champ vide...")
            return
        }
        
        if !checkMediaSelection()
        {
            alert("Veuillez nous indiquer comment vous avez entendu parler de nous...")
            return
        }
        
        let progs = manageSelectedPrograms()
        
        let stringToSend = "name=\(name.text!)&phone=\(phone.text!)&email=\(email.text!)&how=\(pickerChoice)&progs=\(progs)"
        //jsonManager.upload(stringToSend, urlForAdding: "http://localhost/xampp/geneau/ig_po/php/add.php")
        jsonManager.upload(stringToSend, urlForAdding: "http://www.igweb.tv/ig_po/php/add.php")
        clearFields()
        deselectAllButtons()
        resetAllMediaButtonAlphas()
        
        alert("Les données ont été sauvegardées...")
    }
    /* ---------------------------------------*/
    func alert(_ theMessage: String)
    {
        let refreshAlert = UIAlertController(title: "Message...", message: theMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        refreshAlert.addAction(OKAction)
        present(refreshAlert, animated: true){}
    }
    /* ---------------------------------------*/
    func clearFields()
    {
        name.text = ""
        phone.text = ""
        email.text = ""
    }
    /* ---------------------------------------*/
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    /* ---------------------------------------*/
    @IBAction func mediaButtons(_ sender: UIButton)
    {
        resetAllMediaButtonAlphas()
        
        pickerChoice = (sender.titleLabel?.text)!
        
        if sender.alpha == 0.5
        {
            sender.alpha = 1.0
        }
        else
        {
            sender.alpha = 0.5
        }
    }
    /* ---------------------------------------*/
    func resetAllMediaButtonAlphas()
    {
        for index in 0 ..< arrMediaButtons.count
        {
            arrMediaButtons[index].alpha = 0.5
        }
    }
    /* ---------------------------------------*/
    func checkMediaSelection() -> Bool
    {
        var chosen = false
        
        for index in 0 ..< arrMediaButtons.count
        {
            if arrMediaButtons[index].alpha == 1.0
            {
                chosen = true
                break
            }
        }
        
        return chosen
    }
    /* ---------------------------------------*/
}
//=================================













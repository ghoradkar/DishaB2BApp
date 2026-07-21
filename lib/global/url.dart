import 'package:flutter_flavor/flutter_flavor.dart';

///beta
// const String B2BMobileBeta =
//     "http://210.89.42.107:8383/EhatEnterprise/"; // pluscare beta
// const String DubaiB2B =
//     "http://210.89.42.107:8181/EhatEnterprise_DubaiJLT/"; // dubai beta
// const String B2BLifenity =
//     "http://103.251.94.38:8080/MIDMS-Apis/"; // lifenity beta
// const String B2BLifenityLondon = "";// lifenity london beta

///replica
// const String B2BMobileBeta = "http://103.228.151.83:8081/EhatEnterprise_NP/"; // pluscare
// const String DubaiB2B = "http://103.228.151.83:8080/DubaiJLT_replica/";// dubai
// const String B2BLifenity = "http://103.251.94.38:9999/MIDMS-Apis/"; // lifenity
// const String B2BLifenityLondon = "http://103.228.151.83:8080/DISHA_London_Replica/"; // london

///production
const String B2BMobileBeta = "https://disha.pluscare.org/EhatEnterprise/";// pluscare
const String DubaiB2B = "https://genomic.lifenity.ae/DubaiJLT/";// dubai
const String B2BLifenity = "https://disha-api.lifenityhealth.com/MIDMS-Apis/";// lifenity

//production
// String baseurl = FlavorConfig.instance.name == 'DubaiB2B'
//     ? 'https://genomic.lifenity.ae/DubaiJLT/'
//     : 'https://disha.pluscare.org/EhatEnterprise/';

// beta
// String baseurl = FlavorConfig.instance.name == 'B2BMobileBeta'
//     ? 'http://210.89.42.107:8383/EhatEnterprise/'
//     : 'http://210.89.42.107:8181/EhatEnterprise_DubaiJLT/';

//replica pluscare
// String baseurl = FlavorConfig.instance.name == 'B2BMobileBeta'
//     ? 'http://103.228.151.83:8081/EhatEnterprise_NP/'
//     : 'http://103.228.151.83:8080/DubaiJLT_replica/';

//replica dubai
// String baseurl = FlavorConfig.instance.name == 'DubaiB2B'
//     ? 'http://103.228.151.83:8080/DubaiJLT_replica/'
//     : 'http://103.228.151.83:8081/EhatEnterprise_NP/';

String baseurl = FlavorConfig.instance.name == 'B2BMobileBeta'
    ? B2BMobileBeta
    : FlavorConfig.instance.name == 'DubaiB2B'
        ? DubaiB2B
        : B2BLifenity;

// String imagePathWithHeader =
//     "/EhatEnterprise/pathology_routineValueResultLab_PDF.jsp";
// String imagePathWithoutH =
//     "/EhatEnterprise/pathology_routineValueResultWLab_PDF.jsp";

String UNIT = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2bMobilefetchUnitList"
    : "ehat/pluscare/b2bMobilefetchUnitList";
String LOGIN = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2bcheckUserCredentials"
    : "ehat/pluscare/b2bcheckUserCredentials";
String DASHBOARD = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bgetGraphData"
    : "ehat/pluscare/b2bgetGraphData";
String GETPAYMENTDETAIL = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getrazorpayId"
    : "ehat/pluscare/getrazorpayId";
String MARKLIST = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2bgetMarkVisitList"
    : "ehat/pluscare/b2bgetMarkVisitList";
String SAVEPAYMENTDATA = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bupdateRazorPayData"
    : "ehat/phlebotomy/b2bupdateRazorPayData";
String GENERATEMASTERBULKID = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/phlebotomy/B2bsaveBulkDetails"
    : "ehat/phlebotomy/B2bsaveBulkDetails";
String GETRECEIPTID = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/saveBillReceiptDetails"
    : "ehat/billing/b2bmobile/saveBillReceiptDetails";
String GETEMAILANDMOBILE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2b/registration/getEmailandMobile"
    : "ehat/billing/b2bmobile/getEmailandMobile";
String PATIENT_HISTORY = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2b/registration/b2bSearchCallBackReportPatientHistory"
    : 'ehat/mobile/b2b/registration/b2bSearchCallBackReportPatientHistory';
String PATIENT_DETAILS = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2b/registration/b2bMobileGetPatientDetails"
    : 'ehat/mobile/b2b/registration/b2bMobileGetPatientDetails';
String REPORT = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getReportUrl"
    : "ehat/pluscare/getReportUrl";
String B2BQUEUE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2b/registration/b2bGetAllRecordsForBusinessQueue"
    : "ehat/mobile/b2b/registration/b2bGetAllRecordsForBusinessQueue";
String HOSPITAL = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2b/registration/b2bGetHospitalDetails"
    : "ehat/mobile/b2b/registration/b2bGetHospitalDetails";
String PREFIX = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/dropdown/getPrefix"
    : "ehat/dropdown/getPrefix";
String NATIONALITY = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/dropdown/getAllNationalities"
    : 'ehat/dropdown/getAllNationalities';
String COUNTRYCODE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/dropdown/getAllCountryByCountryname"
    : 'ehat/dropdown/getAllCountryByCountryname';
String REFDOC = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/dropdown/getAllDocDetails"
    : 'ehat/dropdown/getAllDocDetails';
String VACCINE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/dropdown/getVaccineType"
    : 'ehat/dropdown/getVaccineType';
String GETBLOODGROUP = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getBloodgroup"
    : "ehat/pluscare/getBloodgroup";
String IDPROOFLIST = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getAllIdproof"
    : "ehat/pluscare/getAllIdproof";

String PATIENTTYPE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getPatienttype"
    : 'ehat/pluscare/getPatienttype';
String DOSE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/dropdown/getDoseType"
    : 'ehat/dropdown/getDoseType';
String REGISTRATION = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2b/registration/save"
    : 'ehat/mobile/b2b/registration/save';
String PREVIOUS_BILL = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/phlebotomy/getPreviousTreatmentPatientDateWiseSearch"
    : 'ehat/billing/getPreviousTreatmentPatientDateWiseSearch';
String ADDTEST = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bSaveCpoe"
    : 'ehat/mobile/b2b/registration/b2bSaveCpoe';
String PAYMENTMODE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/fetchPayList"
    : '/ehat/billing/b2bmobile/fetchPayList';
String CLOSETREATMENT = 'ehat/billing/b2bmobile/closetreatment';
String B2BSEARCH = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bGetAllOpdRecordsDeptwiseForAutoSuggestion"
    : 'ehat/mobile/b2b/registration/b2bGetAllOpdRecordsDeptwiseForAutoSuggestion';
String REPORT_LIST = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bsearchReportingPatient"
    : 'ehat/phlebotomy/b2bsearchReportingPatient';
String HISOPATHLIST = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bsearchReportingPatientHisto"
    : 'ehat/phlebotomy/b2bsearchReportingPatientHisto';
String Accessioning = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/phlebotomy/b2bsearchlabtestpatient"
    : 'ehat/phlebotomy/b2bsearchlabtestpatient';
String AccessioningByID = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/phlebotomy/getpatientbyid"
    : 'ehat/phlebotomy/getpatientbyid';
String AccessioningByName = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/phlebotomy/getpatientbyname"
    : 'ehat/phlebotomy/getpatientbyname';
String REPORT_PDF = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getReportUrl"
    : 'ehat/pluscare/getReportUrl';
String DOWNLOADCUSTOMERREPORT = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/customerledgerPdfUrl"
    : 'ehat/pluscare/customerledgerPdfUrl';
String CHECK_PAYMENT = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/checkPatientFullPayment"
    : 'ehat/billing/b2bmobile/checkPatientFullPayment';
String GENERATED_INVOICE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/getAllBusinessCustomerInvoice"
    : 'ehat/billing/b2bmobile/getAllBusinessCustomerInvoice';
String DETAILED_Print = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/detailprint"
    : 'ehat/billing/b2bmobile/detailprint';
String SUMMARY_Print = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/summeryReceiptPdfUrl"
    : 'ehat/billing/b2bmobile/summeryReceiptPdfUrl';
String SAMPLE_LIST = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getalltestsamples"
    : 'ehat/dropdown/getalltestsamples';
String SEARCH_REPORTS = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/reportingPatientAutoSuggestion"
    : 'ehat/phlebotomy/mobile/reportingPatientAutoSuggestion';
String SEARCH_HISTOPATHBYID = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bgetReportingHistopathPatientById"
    : 'ehat/phlebotomy/b2bgetReportingHistopathPatientById';
String SEARCH_HISTOPATHBYNAME = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2breportingPatientAutoSuggestion"
    : 'ehat/phlebotomy/b2breportingPatientAutoSuggestion';
String SEARCHBYIDANDNAMEGENERATERECEIPT =
    '/ehat/Receipt/B2BAutoSearchGenerateReceipt';
String MARK_VISIT = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2b/registration/getPatientDetails"
    : 'ehat/billing/b2bmobile/getPatientDetails';
String PREVIOUS_BILL_DOWNLOAD = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/getopdallserviceprint"
    : 'ehat/billing/b2bmobile/getopdallserviceprint';
String GET_PATIENT_SEARCH = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2b/registration/autoSuggestionMarkVisit1"
    : 'ehat/mobile/b2b/registration/b2bmobile/autoSuggestionMarkVisit1';
String GET_SERVICES = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getallservices"
    : 'ehat/billing/b2bmobile/getallservices';
String GET_RATE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getB2Bcharges"
    : 'ehat/billing/b2bmobile/getB2Bcharges';
String ALREADY_ADDED_Test = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/fetchPatientsRecordByTreatmentId"
    : 'ehat/billing/mobile/fetchPatientsRecordByTreatmentId';
String FETCHPATIENTDETAISL = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/registration/fetchPatientsRecordByTreatmentId"
    : 'ehat/registration/fetchPatientsRecordByTreatmentId';
String SEND_FOR_PROCESSING = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bsendtolab"
    : 'ehat/phlebotomy/b2bsendtolab';
String UPLOAD_DOCUMENT = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2b/registration/uploadDocsDetails"
    : 'ehat/mobile/b2b/registration/uploadDocsDetails';
String PREPAID_DATA = 'ehat/billingsummary/b2bgetPrepaidCustomerDetails';
String POSTPAID_DATA = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/getAllBusinessCustomerInvoice"
    : 'ehat/billing/b2bmobile/getAllBusinessCustomerInvoice';
String SAMPLE_COLLECT = 'ehat/phlebotomy/collectB2BSampleMobile';
String SAMPLE_REJECT = 'ehat/phlebotomy/mobile/rejectB2BSample';
String SAMPLE_SUBMIT = 'ehat/phlebotomy/submitB2BSampleMobile';
String CUST_NAME = 'ehat/dropdown/labNameDropdown';
String CUST_TYPE = 'ehat/dropdown//mobile/getAllBusinessMaster';
String SEARCH_B2BRECORDS = 'ehat/phlebotomy/mobile/searchB2BRecords';
String GENDER_PREFIX = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/dropdown/autofetchgenderbyprefix"
    : 'ehat/dropdown/autofetchgenderbyprefix';
String ADVANCE_UTILIZATION_PDF = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bAdvanceUtilizationReportPdf"
    : 'ehat/billingsummary/b2bAdvanceUtilizationReportPdf';
String CONSUMPTION = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getPrePostConsumtionDetails"
    : 'ehat/mobile/b2b/registration/getPrePostConsumtionDetails';
String CONSUMPTIONAVAILABLEAMT = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getAllCustomerDetails"
    : 'ehat/billing/b2bmobile/getAllCustomerDetails';
String ADVANCE_UTILIZATION = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getPrepaidFundUtilizationDetails"
    : 'ehat/billing/b2bmobile/getPrepaidFundUtilizationDetails';
String CUSTOMERLEDGERLIST = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getDetailedListforLedger"
    : 'ehat/billing/b2bmobile/getDetailedListforLedger';
String CUSTOMERRECEIPTPAYMENTDET = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getBillReceiptDetails"
    : 'ehat/billing/getBillReceiptDetails';
String POSTPAIDLEDGERDETAILS = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/b2bgetPostpaidLedgerReport"
    : 'ehat/billing/b2bgetPostpaidLedgerReport';
String TATSTATUSLIST = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bgetTatStatusReport"
    : 'ehat/phlebotomy/b2bgetTatStatusReport';
String TATSTATUSLISTBYNAME = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bgetpatientsuggestions"
    : 'ehat/phlebotomy/b2bgetpatientsuggestions';
String TATSTATUSLISTExcel = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bgetTatStatusReportExcel"
    : 'ehat/phlebotomy/b2bgetTatStatusReportExcel';
String POSTPAIDLEDGEREXCEL = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/b2bgetPostpaidLedgerReportExcel"
    : '/ehat/billing/b2bgetPostpaidLedgerReportExcel';
String SAME_SAMPLE = 'ehat/phlebotomy/b2bgetBarcodeIdFromSampleWise';
String B2B_PREVIOUS_BILL_SEARCH = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/getB2BPreviousBillAuto"
    : 'ehat/billing/mobile/getB2BPreviousBillAuto';
String DUPLICATE_TEST = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getpathologypredetails"
    : 'ehat/dropdown/getpathologypredetails';
String VALIDATE_USER = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/checkUserNameandPasswordByRefundApproved"
    : 'ehat/phlebotomy//b2bmobile/checkUserNameandPasswordByRefundApproved';
String DELETE_TEST = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/cancelLabTest"
    : 'ehat/phlebotomy/cancelLabTest';
String DUPLICATE_PACKAGE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/checkDuplicateServicesFromPackage"
    : 'ehat/phlebotomy/b2bmobile/checkDuplicateServicesFromPackage';
String TEST_LIST_PACKAGE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getSampleWiseProfileFromPackage"
    : 'ehat/phlebotomy/b2bmobile/getSampleWiseProfileFromPackage';
String TESTINPACKAGE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/getPackagedataforOpd"
    : "ehat/phlebotomy/b2bmobile/getPackagedataforOpd";
String AddDoctor = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/b2b/registration/saveDocDetails"
    : "ehat/billing/b2bmobile/saveDocDetails";
String DELETETESTFROMPACKAGE = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/pluscare/b2bdeleteOnClickForPackageOpd"
    : "ehat/phlebotomy/b2bdeleteOnClickForPackageOpd";
String GENERATERECEIPT = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/getList"
    : 'ehat/billing/getList';
String PATIENTBILLINGDETAILS = FlavorConfig.instance.name == "B2BLifenity"
    ? "api/mobile/billing/getpatientbilldetails"
    : 'ehat/billing/b2bmobile/getpatientbilldetails';
String SAVEGENERATEDRECEIPT = 'ehat/Receipt/saveBillDeatilsMob-model';
String DOWNLOADBILL = 'b2b_bill_service_receipt.jsp';

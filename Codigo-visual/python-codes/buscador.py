from bs4 import BeautifulSoup
import requests

companies = [
    "Rochester Institute of Technology",
    "Rod Morgan Associates",
    "ROKKO Systems Pte Ltd",
    "Rokko Technologies Co., Ltd",
    "Roos Instruments, Inc.",
    "RORZE CORPORATION",
    "Royce Instruments",
    "RS Technologies Co., Ltd.",
    "RTCK Co., Ltd.",
    "RUSSELL CO., LTD",
    "Ruth Cleaning Technology Co., Ltd.",
    "Ryokosha Co., Ltd.",
    "S.E.R Corporation",
    "S3 Alliance GmbH",
    "Sabanci University",
    "Saesol Diamond Cp., Ltd.",
    "Safe World Engineering",
    "Safety Excellence Group",
    "Sakura Seal Taiwan Co., Ltd.",
    "Salt River Project",
    "Salus Engineering International",
    "Samco Inc.",
    "SAMIL FLONTECH CO.,LTD.",
    "Samsung C&T",
    "Samsung Electronics",
    "SAMSUNG SDI",
    "Samurai Spirit Inc.",
    "Samyoung Pure Chemicals Co., Ltd.",
    "Sandia National Laboratories",
    "SandTek Semiconductor Technology (SHANGHAI) Co., Ltd.",
    "Santa Barbara City College",
    "SANYU REC CO., LTD",
    "Saratoga Technology International",
    "SAS Technology (Shanghai) Co., Ltd",
    "SavanSys Solutions LLC",
    "SB TECH Corporation",
    "SC Solutions, Inc.",
    "SCH Electronics Co., Ltd.",
    "Schenker AG",
    "Schmidt Scientific Taiwan Ltd.",
    "Schmidtek Ltd.",
    "scia Systems GmbH",
    "Science Probe Co.,Ltd",
    "Scientech Corp.",
    "Scope AR",
    "SCREEN Semiconductor Solutions Co., Ltd.",
    "SE Technologies Corp.",
    "Seagate Technology LLC",
    "SEBO MEC",
    "SEC CO., LTD.",
    "secureWISE, LLC",
    "Seica Inc.",
    "SEIWA OPTICAL CO., LTD",
    "Selling-Ware Co., Ltd.",
    "SELVID Co., Ltd.",
    "SEMCNS Co., Ltd.",
    "SEMES Co., Ltd.",
    "Semiconductor and Electronics Industries in the Philippines, Inc. (SEIPI)",
    "Semiconductor Equipment Corporation",
    "Semiconductor Global Solutions",
    "Semiconductor Technologies Singapore Pte Ltd",
    "Semics Inc.",
    "Semi-ence",
    "Semight Instruments Co.,Ltd.",
    "Semilab Semiconductor Physics Laboratory Co. Ltd.",
    "SemiLink Materials, LLC",
    "Semiplastic Co., Ltd. / AGRU Taiwan",
    "SEMI-TECH Co., Ltd.",
    "Senju Metal Industry Co., Ltd.",
    "SENTECH Instruments GmbH",
    "Sentronics Metrology GmbH",
    "SEOIL E&M CO., LTD.",
    "Service, Support Specialties, Inc. DBA: S-Cubed",
    "SET Corporation S.A.",
    "Sewoo Incorporation",
    "SFA Semicon",
    "SGC Equipment",
    "SGL Carbon SE",
    "SGS Japan Inc.",
    "SGS Taiwan Ltd.",
    "Shaghai Fairfield Electronic Technology Co., Ltd",
    "Shandong Keda Dingxin Electronic Technology Co., Ltd",
    "Shanghai Advanced Engineering Technology, Inc.",
    "Shanghai Dongxu Electronic Technology Co., Ltd",
    "SHANGHAI DUKE ELECTRONICS CO., LTD",
    "Shanghai Eaco Gases Co., Ltd",
    "Shanghai Fortrend Technology Co., Ltd",
    "Shanghai Huasong Enterprise",
    "Shanghai Leading Semiconductor Technology Development Co., Ltd.",
    "Shanghai Lieth Precision Equipment Co., Ltd",
    "Shanghai Lush Mount Int'l Trade Ltd.",
    "Shanghai Matfron Technology Co., Ltd",
    "Shanghai Merlin Test Technologies Co.,Ltd",
    "Shanghai Micro Electronics Equipment (Group) Co., Ltd.",
    "Shanghai Mirros Metal Surface Treatment Technology Co., Ltd.",
    "Shanghai Miya Technology Co., Ltd.",
    "Shanghai Qianghua Industrial Corporation",
    "Shanghai Safeslab Technology Co., Ltd.",
    "Shanghai Shengjian Environment Technology Co, Ltd",
    "Shanghai Simgui Technology Co., Ltd.",
    "Shanghai Simpure Gas Technology Co., Ltd.",
    "Shanghai Sinyang Semiconductor Materials Co., Ltd",
    "Shanghai STN Electrical & Machinery Co., Ltd",
    "Shanghai Supex Industrial Supply Co., Ltd.",
    "Shanghai Testrong Technologies Co., Ltd",
    "Shanghai Zhonghui Electronics Technology Co., Ltd",
    "ShanghaiHYI Electronic Technology Co., LTD",
    "SHELLBACK Semiconductor Technology",
    "SHENG CHUAN Technology CO., LTD.",
    "Shenmao Technology Inc.",
    "Shenxhen Tensun Precision Equipment Co., Ltd",
    "ShenYang Academy of Instrumentation Science Co., Ltd",
    "Shenyang Fortune Precision Equipment Co., Ltd.",
    "Shenyang Heyan Technology Co., Ltd",
    "SHEN-YUEH TECHNOLOGY CO., LTD.",
    "Shenzhen Axxon Automation Co., Ltd",
    "SHENZHEN BIAOPU SEMICONDUCTOR TECHNOLOGY CO.,LTD",
    "SHENZHEN CHUANGZHI SEMI-LINK TECHNOLOGY CO., LTD",
    "Shenzhen Chunshui No. 1 Science and Technology Co., Ltd.",
    "SHENZHEN DGT CO.,LTD",
    "SHENZHEN DONG RONG XING YE ELECTRONICS CO., LTD.",
    "Shenzhen Gorgeous Technology Co., Ltd.",
    "Shenzhen Han´s Assembly & Testing Technology Company Limited",
    "Shenzhen Merry Precise Electronic Co., Ltd",
    "Shenzhen MicroASM Semiconductor Technology Co., Ltd",
    "Shenzhen Newway Photomask Making Co., Ltd.",
    "Shenzhen Secon Technical Industry Co., Ltd",
    "Shenzhen Shenkeda Semiconductor Technology Co., LTD.",
    "Shenzhen Tete Semiconductor Equipment Co., Ltd.",
    "Shenzhen Yaotong Technology Co., Ltd.",
    "Shibaura Mechatronics Corp.",
    "Shibuya Corporation",
    "Shimadzu Corporation",
    "Shin-Etsu Handotai Co., Ltd.",
    "Shinko Seiki Co., Ltd.",
    "Shinwa Controls Co. Ltd.",
    "Shiny Chemical Industrial Co., Ltd.",
    "SHYAN SHENG HITECH CO., LTD.",
    "Sichuan Injet Electric Co., LTD.",
    "Siconnex customized solutions GmbH",
    "SICREAT (Suzhou) Semitech Co., Ltd",
    "Sidea Semiconductor Equipment (Shenzhen) Co.,Ltd",
    "SIEGERT WAFER GmbH",
    "Siemens AG - Vertical Semiconductor",
    "Siemens Digital Industries Software",
    "SiFive Inc.",
    "SIGMA SYSTEM CO.,LTD.",
    "SIGMA Technology Corporation",
    "SIGURD MICROELECTRONICS CORP.",
    "Sikama International, Inc.",
    "Silicon Assurance",
    "Silicon Catalyst",
    "Silicon Connection Pte Ltd",
    "Silicon Future Manufacturing Company Ltd.",
    "Siliconware Precision Industries Co., Ltd.",
    "Sil-More Industrial Ltd.",
    "Silpac International Limited"
]

def get_company_info_from_rocketreach(company_name):
    # Formatear el nombre de la compañía para la URL de RocketReach
    company_name_formatted = company_name.replace(" ", "-").lower()
    url = f"https://rocketreach.co/{company_name_formatted}-profile_b5c6"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers)
    
    if response.status_code != 200:
        return "Error al acceder a la página", "Error al acceder a la página"

    soup = BeautifulSoup(response.text, 'html.parser')

    employees = "Número de empleados no encontrado"
    revenue = "Ganancia no encontrada"

    try:
        # Intentar encontrar el número de empleados
        employees_snippet = soup.find('div', class_='company-overview__employees')
        if employees_snippet:
            employees = employees_snippet.find('span', class_='sc-dlnjwi').text.strip()

        # Intentar encontrar la ganancia
        revenue_snippet = soup.find('div', class_='company-overview__revenue')
        if revenue_snippet:
            revenue = revenue_snippet.find('span', class_='sc-dlnjwi').text.strip()

    except AttributeError as e:
        return f"Error: {str(e)}", f"Error: {str(e)}"
    
    return employees, revenue

# Uso de ejemplo
for company in companies:
    employees, revenue = get_company_info_from_rocketreach(company)
    print(f"{company}:")
    print(f"    Número de empleados: {employees}")
    print(f"    Ganancia: {revenue}")

# Power BI analysis

The dashboard layer was used to turn the prosthesis-management database into interpretable operational views covering patients, prostheses, clinicians, laboratories and consultations.

## Reported dashboard views

- patient distribution by sex
- prosthesis types
- geographic distribution of patient addresses
- laboratory locations
- patients per physician
- prostheses by material
- consultations over time
- consultations per physician
- patient age groups

## Selected reported results

| Result | Value |
| --- | ---: |
| Female patients | 113 (56.5%) |
| Male patients | 87 (43.5%) |
| Dental crowns | 29 |
| Dental implants | 28 |
| Total prostheses | 25 |
| Partial prostheses | 18 |

The project report describes a relatively stable clinical workload over time, a geographically distributed patient/laboratory network and a mix of prosthesis types and materials. These dashboard views were intended to support rapid interpretation of the relational data rather than require users to inspect raw database tables directly.

## Data preparation before visualisation

The documented pipeline included:

1. selecting real technical/catalogue information and synthetic patient records for privacy;
2. removing duplicates and checking missing fields;
3. standardising categories such as materials and locations;
4. aligning column names and data types with the MySQL logical model;
5. importing prepared CSV data through Python/pandas/SQLAlchemy;
6. analysing the resulting database in Power BI.


#################
###Simulations###
#################

epi_donothing = SEIR(dateShelterInPlace = as.Date('2021-11-01'),
                     dateRelaxIntervention = as.Date('2021-12-31'))

epi_shelterinplace = SEIR(dateShelterInPlace = as.Date('2020-03-16'),
                          dateRelaxIntervention = as.Date('2021-12-31'))

epi_shelterrelax = SEIR(dateShelterInPlace = as.Date('2020-03-16'),
                        dateRelaxIntervention = as.Date('2020-05-01'))

epi_relaxhomedist = SEIR(dateShelterInPlace = as.Date('2020-03-16'),
                         dateRelaxIntervention = as.Date('2020-04-30'),
                         dateRelaxandHomedistance = as.Date('2020-05-01'))

epi_relaxisolate1 = SEIR(prop.isolate = 0.2, dateShelterInPlace = as.Date('2020-03-16'),
                         dateRelaxIntervention = as.Date('2020-05-01'))

epi_relaxisolate2 = SEIR(prop.isolate = 0.5, dateShelterInPlace = as.Date('2020-03-16'),
                         dateRelaxIntervention = as.Date('2020-05-01'))
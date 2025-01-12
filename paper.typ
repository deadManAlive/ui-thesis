#import "@preview/charged-ieee:0.1.3": ieee

#show: ieee.with(
  title: [Development of a Ray Tracing-Based Radio Wave Propagation Modelling Application in Indoor Environment for Wi-Fi Access Point Placement],
  abstract: [
    In this study, a graphical software has been developed to model radio frequency propagation in Wi-Fi frequencies of 2.4 GHz and 5 GHz. The developed algorithm models radio frequency propagation for a 2-dimensional floorplan environment by ray tracing approach with shooting and bouncing rays (SBR) method, reflection and transmission modelling based on Geometrical Optics (GO) principle, and diffraction modelling based on Geometric Theory of Diffraction (UTD) with goal to predict the perceived power and path loss at some points in the modelled room. The implemented program is able to predict the path loss of a simple floorplan with 13% error rate, both in 2.4 GHz and 5 GHz. In real floorplan scenario, the program able to reach satisfying error rates of 10.3% in 2.4 GHz and 9.3% in 5 GHz, showing an agreement with asymptotic approach that prefers higher frequencies. The program exhibits a substantial error increase of up to 40% in regions that are challenging for rays to penetrate in 2.4 GHz, while it gives relatively fair error rate up to 10% in 5 GHz.
  ],
  index-terms: (
    "access point",
    "propagation modelling",
    "GUI application",
    "ray tracing",
    "shooting and bouncing rays",
    "RSSI"
  ),
  authors: (
    (
      name: "Muhammad Rafky Alfarrakhan.S",
      department: [Electrical Engineering Department],
      organization: [Faculty of Engineering, Universitas Indonesia],
      location: [Depok, West Java, Indonesia],
      email: "muhammad.rafky91@ui.ac.id"
    ),
  ),
  bibliography: bibliography("sources.bib"),
  paper-size: "a4"
)

#set image(height: 16em)

#let bup(v) = [$bold(upright(#v))$]

= Ray Tracing in Electromagnetics

In physics, ray tracing (RT), as in contrast to one of it's widespread application as graphic rendering technique, is a geometrical approach in analyzing the flow of radiant energy by means of ray representation@robinson_basic_2017. As such, for ray tracing to be an applicable method, this energy propagation, mainly in the form of wave, must be representable or may be approximated by ray modelling. In accoustics, for example, the flow of sound wave can be approximated by means of geometrical accoustics@krautkramer_geometrical_1990, while another example is seismic ray theory that enables ray tracing application in seismic wave propragation analysis@cerveny_seismic_2001.

== Geometrical Optics

In computational electromagnetics (CEM) itself, ray tracing is based on the principle of geometric optics (GO) as an asymptotic approach to the solution of Maxwell equations, which can be derived from Fermat's principle of least team@chaves_introduction_2017, or in this study, via Luneberg-Kline expansion in the form of@dominek_additional_1987

$ hat(bup(E))(bup(r), omega) = e^(-j k phi.alt(bup(r))) sum_(i in NN) (hat(bup(E))_i (bup(r)))/(j omega)^n $ <paper:lkexp>

where a $hat(bup(E)) : RR^3 times RR arrow CC^3$ is electrical field $bup(E) : RR^3 times RR_+ arrow RR^3$ in frequency domain, $phi.alt(bup(r))$ is phase function, and $hat(bup(E))_i : RR^3 arrow CC^3$ is the $i$-th order component of the asymptotic expansion. Substituting @paper:lkexp to the Helmholtz equation of the electromagnetical wave with the form

$ (nabla^2 + n^2k^2)hat(bup(E))(bup(r), omega) = 0 $

and by considering asymptotic assumption $omega arrow infinity$ for high frequency approximation, it would five raise to

$ norm(nabla phi.alt(bup(r))) = n $

that denotes that the direction of electromagnetical wave propagation at a point in the space is determined by its eikonal $nabla phi.alt(bup(r))$. @paper:img1 shows wavefronts as surface level of $phi.alt(bup(r))$, eikonal $p = nabla phi.alt(bup(r))$ as its gradient, with direction of a certain point in the wavefront is the direction of the ray.

#figure(
  image("chapters/assets/wavefront.png"),
  caption: [Geometric relation between ray path, wavefront, and eikonal $p$@chaves_introduction_2017]
) <paper:img1>

\

This then may be further consolidated by showing that the time-averaged Poynting vector $angle.l bup(S) angle.r$ that represents the magnitude and direction of a propagating electromagnetical wave has direction determined by the eikonal, more specifically as

$ angle.l bup(S) angle.r = 2c angle.l w_r angle.r nabla phi.alt (bup(r)) $

where $angle.l w_e angle.r$ is time-averaged electrical energy density.

== Free-Space Attenuation

The free-space attenuation of the wave from a source can be analyzed by considering the propagating wavefront as an astigmatic ray tube with radii $rho_1$ and $rho_2$, which gives the attenuation as

$ A(s) = sqrt((rho_1 rho_2)/((rho_1 + s)(rho_2 + s))) $

where $s$ is the displacement from source.

== Reflection and Transmission

Reflection and transmission phenomenon in geometrical optics can be interpreted as the implication of continuity principle for incident and outgoing rays at mediums interface, as seen in @paper:img2. There, at the interface ($z = 0$), the relation between scattered waves is

$ hat(bup(z)) times (hat(bup(y))E_0e^(-j bup(k)_i dot bup(r)) + hat(bup(y)) Gamma E_0e^(-j bup(k)_r dot bup(r))) = hat(bup(z)) times hat(bup(y)) T E_0 e^(-j bup(k)_t dot bup(r))  $

#figure(
  image("chapters/assets/reftran.jpg"),
  caption: [Reflection and transmission of $(bup(E)_i, bup(H)_i)$ at an interface@balanis_balanis_2024]
) <paper:img2>

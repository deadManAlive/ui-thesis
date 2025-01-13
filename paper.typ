#import "@preview/lovelace:0.3.0": *
#import "charged-ieee/lib.typ": ieee

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
      name: "Eko Tjipto Rahardjo",
      department: [Department of Electrical Engineering],
      organization: [Faculty of Engineering, Universitas Indonesia],
      location: [Depok, West Java, Indonesia],
      email: "eko@eng.ui.ac.id"
    ),
    (
      name: "Muhammad Rafky Alfarrakhan.S",
      department: [Department of Electrical Engineering],
      organization: [Faculty of Engineering, Universitas Indonesia],
      location: [Depok, West Java, Indonesia],
      email: "muhammad.rafky91@ui.ac.id"
    ),
  ),
  bibliography: bibliography("sources.bib"),
  paper-size: "a4"
)

#set image(height: 16em)
#show figure.caption: set align(center)

#let bup(v) = [$bold(upright(#v))$]

= Ray Tracing in Electromagnetics

In physics, ray tracing (RT), as in contrast to one of it's widespread application as graphic rendering technique, is a geometrical approach in analyzing the flow of radiant energy by means of ray representation@robinson_basic_2017. As such, for RT to be an applicable method, this energy propagation, mainly in the form of wave, must be representable or may be approximated by ray modelling. In accoustics, for example, the flow of sound wave can be approximated by means of geometrical accoustics@krautkramer_geometrical_1990, while another example is seismic ray theory that enables RT application in seismic wave propragation analysis@cerveny_seismic_2001.

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

Reflection and transmission phenomenon in GO can be interpreted as the implication of continuity principle for incident and outgoing rays at mediums interface, as seen in @paper:img2. There, at the interface ($z = 0$), the relation between scattered field can be formulated as

$ hat(bup(z)) times (hat(bup(y))E_0e^(-j bup(k)_i dot bup(r)) + hat(bup(y)) Gamma E_0e^(-j bup(k)_r dot bup(r))) = hat(bup(z)) times hat(bup(y)) T E_0 e^(-j bup(k)_t dot bup(r))  $

where phase continuity at $z = 0$ would enforce

$ bup(k)_i dot bup(r) = bup(k)_r dot bup(r) = bup(k)_t dot bup(r) |_(z=0) $

with the fact that $norm(bup(k))$ is intrinsic to the medium such as $norm(bup(k)_i) = norm(bup(k)_r) = k_1$ and $norm(bup(k)_t) = k_2$. This will give the basic relation of

$ k_1 sin theta_i = k_1 sin theta_r = k_2 sin theta_t $

which encompasses Snell's law for reflection and refraction.

#figure(
  image("chapters/assets/reftran.jpg"),
  caption: [Reflection and transmission of $(bup(E)_i, bup(H)_i)$ at an interface@balanis_balanis_2024]
) <paper:img2>

\

The same approach would also give us Fresnel equations to calculate $Gamma$ and $T$ as fraction of the incident field as either reflection or transmission:

$ Gamma_(perp,parallel) = (eta_2 cos theta_(i,t) - eta_1 cos theta_(t,i))/(eta_2 cos theta_(i,t) + eta_1 cos theta_(t,i)) $ <paper:gamma>

$ T_(perp,parallel) = (2 eta_2 cos theta_i)/(eta_2 cos theta_(i,t) + eta_1 cos theta_(t,i)) $ <paper:tau>

\

For dieletrics, $eta$ can be calculated as

$ 1/sqrt(epsilon' - j sigma/(epsilon_0 omega)) $

with real part of relative permittivity of the material $epsilon'$, its conductivity $sigma$, and angular frequency of the wave $omega$@international_telecommunication_union_effects_2023.

== Diffraction

While plain GO may easily explain reflection and transmission of propagating wave in a homogen medium or at an interface, it will present problems discontinuities around obstacles due to its unability to explain forward scattered field in existence of obstacles. One solution is to introduce a new class of rays, that spreads around wedges or vertices, akin to what happen in Huygens model of diffraction. This spreading rays then can fill up discontinuities of field in area III as can be seen in @paper:diffr. This approach is known as geometric theory of diffraction (GTD)@keller_geometrical_1962. The total field $bup(E)_Sigma$ around the wedges can be aproximated as

#[
  #let pa = [$phi.alt$]
  $ 
    bup(E)_Sigma = cases(
      bup(E)_r + bup(E)_i + bup(E)_d quad &0 < pa < pi - pa',
      bup(E)_i + bup(E)_d &pi - pa' < pa < pi + pa',
      bup(E)_d &pi + pa' < pa < n pi
    )
  $ <paper:diftot>

  where $bup(E)_i$ is incident field, $bup(E)_r$ is reflected field, and $bup(E)_d$ is diffracted field.

  #figure(
    image("chapters/assets/diffr.jpg"),
    caption: [Partition of area around a wedge@paknys_applied_2016]
  ) <paper:diffr>

  While may help help in explaining the forward scattered field begin a diffracting object, GTD introduces singularities at area boundaries, namely reflection shadow boundary (RSB) at $pa + pa' = pi$ and incident shadow boundary (ISB) at $pa - pa' = pi$. One solution is to extend GTD where areas between boundary is defined as transition field@balanis_balanis_2024 by introducing a uniform function to the equation. This approach is known as uniform (geometric) theory of diffraction (UTD).

  One problem with GTD that is not addressed by UTD is that both method only workds for PEC material, in other words, no transmission field component in total field around diffraction wedge. This is due to far complex interactions happens when EM field hits dielectric materials, more so for diffracting object. One of the approach is to introduce yet another class of rays, that is surface current ray, which represents surface current occured at dielectric surface under EM field@rojas_electromagnetic_1988.

  Other approach, considering a think slab of dielectric, directly add diffraction rays to the total field@burnside_high_1983. This approach simplifies diffraction from dielectric slabs into product of Fresnel coefficients and diffraction coefficient, more precisely as

  $ D_(s,h)(pa,pa') = [(1-T)D(pa-pa') + Gamma D(pa+pa') ] $

  with

  $
    R_(perp, parallel) = (R_(1(perp,parallel))(1-P_d^2 P_a))/(1-R^2_(1,(perp,parallel))P_d^2 P_a)
  $

  $
    T_(perp, parallel) = ((1 - R_(1(perp,parallel)))P_d^2 P_t)/(1-R^2_(1,(perp,parallel))P_d^2 P_a)
  $

  and

  $
    D(pa minus.plus pa') = (-e^(-j pi / 4))/(2 sqrt(2 pi k)) (F[k L a(pa minus.plus pa')])/cos((pa minus.plus pa')/2)
  $

  where

  $
    P_d = exp(-j k' d/(cos theta_t))
  $
  $
    P_a = exp(j k 2 d/(cos(theta_r)) sin(theta_t) sin(theta_i))
  $
  $
    P_t = exp(j k d/(cos(theta_t)) cos(theta_i - theta_t))
  $
]

== Resulting Field

Because each ray represents a propagation of a fraction of a wavefront which is itself based on a Maxwell equations that is linear, the total field in a point in space is the superposition of all field generated by some certain ray that has significant influence to the total field in the area. 

For each ray, the resulting field can be calculated as

$ E_R = E_0 f_T f_R [product_i A_i Gamma_i product_j A_j T_j product A_k D_k] (e^(-j k s))/s $

where $E_R$ is resulting field, $E_0$ is initial field strength, $A_(i,j,k)$ is spatial attenuation, $f_(T,R)$ is radiation pattern, and $s$ is total ray length@balanis_balanis_2024@schaubach_ray_1992@seidel_site-specific_1994. Then, the superposition is simply defined as

$ E_"total" = sum E_(R,"valid") $

with ray validity is determined by wether it intersect with the reception sphere of the transmitter/target point or not. The reception sphere size is usually defined as@schaubach_ray_1992@seidel_site-specific_1994@zhengqing_yun_development_2001

$ r = (alpha s)/sqrt(3) $

\

The path loss as the ratio between transmitted and received power then can be defined as

$
  L = P_R/P_T = 1/(8 P_0) abs(bup(E)_"total")^2/eta_0 lambda^2/pi
$

with $P_0$ source power and $lambda$ transmitted signal wavelength.

= Algorithm

Ray generation is the first step in ray tracing where the modelling space is filled with rays that relevant to analysis. There are two methods to generate ray, image method and shooting and bouncing (SBR) method.

In image method, the exact path that form straight line between source and target is determined by analyzing reflections and sequence of reflection to find which path make the receiver as the image of the source. While giving the accurate path, this method is not efficient for complex space geometry due to its reliance to its recursive properties of algorithm, thus it has $cal(O)(N^M)$ time complexity.

SBR method, on the other hand, launch homogen rays from the source and let it interact with objects in space, and then valid path is determined by way of reception sphere. Due it's linear nature in launcing, the algorithm has less time complexity of $cal(O)(N M)$. Another advantage of SBR is that phenomenon other than reflection can be easily integrated to the algorthm.

== Shooting and Bouncing Rays

Due to its modular nature, SBR is used as the fundamental framework in the implementation where later Fresnel coefficients calculation can be integrated, and also diffraction coefficient with small adjustment.

#[
  #set math.equation(numbering: none)
  
  #figure(
    [
      #set math.equation(numbering: none)
      #pseudocode-list(
        indentation: 2em,
        booktabs: true,
        numbered-title: [_Shooting and Bouncing Rays_])[
      - *variables*:
      + $W subset RR^2 times RR^2$
      + $n in NN$
      + $bup(o)_0 in RR^2$
      + $bup(d)_0 in RR^2$
      - *SBR*:
      + *for each* $i = 1,2,...,n$ *do*
        + *for each* $(bup(s), bup(e)) in W$
          + $bup(w) = bup(e) - bup(s)$
          + $bup(p)_1 = bup(s) - bup(o)_(i-1)$
          + $bup(p)_2 = -bup(d)_(i-1)$
          + $bup(p)_3 = "Rot"_(pi slash 2)(bup(w))$
          + $bup(o)_i = bup(s) + norm(bup(p)_2 times bup(p)_1)/(bup(p)_2 dot bup(p)_3) dot bup(w)$
          + $bup(d)_i = "Refl"_(angle bup(w))(bup(d)_(i-1))$
        + *end*
      + *end*
      + return $S = union.big_(i in Q) (bup(o)_i, bup(d)_i)$
      ]
    ],
    supplement: [Algorithm],
    kind: "algorithm",
  ) <paper:algo>
]

@paper:algo shows a basic implementation of SBR, where ray object $bup(r)$ is defined as parametric vector equation

$ bup(r)(t) = bup(o) + t bup(d), space t >= 0 $

and wall segments $bup(w)$ in wall set $W$ also a parametric vector equation

$ bup(w)(t) = (1-t)bup(s) + t bup(e), space 0 <= t <= 1 $

\

This algorithm works by recursively shoot a single ray by information of previous shot, generating sequence of rays, until iteration limit $n$ is reached.

== Reflection, Transmission, and Diffraction

Reflection, Transmission, and Diffraction was choosen for this application due to its close relation and mathematical proximity to geometric ray representation, in contrast to phenomenon such as absorption, diffuse reflection, and others.

To integrate those phenomenon to SBR, one such way is to embed Fresnell and diffraction coefficient into ray representation, expanding ray object to

$ bup(R) = (bup(o), bup(d), bup(Gamma), bup(T), bup(D), s) $

and due to sole dependence of Fresnel and UTD equation to angle information, which is contained in the SBR algorithm, the calculation can be easily embedded to inner loop of @paper:algo as seen in @paper:algo2

#[
  #set math.equation(numbering: none)
  
  #figure(
    [
      #set math.equation(numbering: none)
      #pseudocode-list(
        indentation: 2em,
        booktabs: true,
        numbered-title: [_SBR with Fresnel_])[
      + ...
      + $sigma_i = norm(bup(o)_(i-1) - bup(o)_i)$
      + $sigma_s = norm(bup(o)_(i+1) - bup(o)_i)$
      + $(bup(Gamma)_i, bup(T)_i) = "Fresnel"(bup(d)_(i-1))$
      + $bup(D)_i = "UTD"(bup(d)_(i-1), bup(d)_i, sigma)$
      + ...
      + return $S = union.big_(i in NN) (bup(o)_i, bup(d)_i, bup(Gamma)_i, bup(T)_i, bup(D)_i, sigma_i)$
      ]
    ],
    supplement: [Algorithm],
    kind: "algorithm",
  ) <paper:algo2>
]

where $sigma_(i,s)$ is incident and scattered ray length, $"Fresnel"$ is function based on Fresnel equation @paper:gamma and @paper:tau, and $"UTD"$ is function based on UTD or its expansion.

One more thing to add is diffraction ray generation. This can be easily implemented as separate procedure sequential to SBR, like in @paper:algo3, where $p$ is diffraction point in space, that can be wedge, vertice, etc., $bup(r)$ is ray, $"ISect"$ check if $bup(r)$ cross reception sphere of $p$, and $"SBR"(p)$ triggers another launch near $p$.

#[
  #set math.equation(numbering: none)
  
  #figure(
    [
      #set math.equation(numbering: none)
      #pseudocode-list(
        indentation: 2em,
        booktabs: true,
        numbered-title: [_SBR with Fresnel_])[
      + $p in RR^2 times RR^2$
      + $bup(r) = (bup(o), bup(d), ...)$
      + *if* $"ISect"(bup(r), p)$
        + $"SBR"(p)$
      + *end if*
      ]
    ],
    supplement: [Algorithm],
    kind: "algorithm",
  ) <paper:algo3>
]

= Result
#place(
  top+center,
  scope: "parent",
  float: true,
  [
#figure(
  image("chapters/assets/simplefray.png", height: 24em),
  caption: [FRAY in simple floorplan]
)])

Comparison of FRAY, the written application, against Altair FEKO 2022.3 Student Edition ProMan with Standard Ray Tracing configuration by comparing a . For a simple closed polygon 2D floorplan for 2.4 GHz yields

#figure(
  image("chapters/assets/s24.png", height: 20em),
  kind: table,
  caption: [FEKO vs FRAY for simple floorplan on 2.4 GHz]
)

while in 5 GHz

#figure(
  image("chapters/assets/s5.png", height: 20em),
  kind: table,
  caption: [FEKO vs FRAY for simple floorplan on 5 GHz]
)

\

This shows no improvement despite asymptotic property that prevers high frequencies. One thing to point out in these two comparison is that FRAY errs in LOS. This may be explained as effect of closed nature of the floorplan.

#place(
  top+center,
  scope: "parent",
  float: true,
  [
    #figure(
      image("chapters/assets/realfray.png", height: 24em),
      caption: [FRAY in real floorplan]
    )
  ]
)


For real floorplan, building I floor 2nd EE UI is used. For 2.4 GHz, comparison yields

#figure(
  image("chapters/assets/plreal24g.png", height: 20em),
  kind: table,
  caption: [FEKO vs FRAY for a real floorplan on 2.4 GHz]
)

while 5 GHz

#figure(
  image("chapters/assets/plreal5g.png", height: 20em),
  kind: table,
  caption: [FEKO vs FRAY for a real floorplan on 5 GHz]
)

\

Now the result more what asyntotic approach should resembles and also there's no LOS discrepancy as in simple closed floorplan.While error still may reach around 20%, the average error is just 10%, enough to give an overal prediction on signal coverage.

#figure(
  image("chapters/assets/test.png"),
  caption: [FEKO vs FRAY for a real floorplan on 2.4 GHz]
) <paper:realplan>

Comparing both FEKO and FRAY to real world measurement using POCO X3 NFC using Fing application for 4 different points in the room yields

#figure(
  image("chapters/assets/res.jpg", width: 30em, height: 13em),
  kind: table,
  caption: [FEKO vs FRAY vs measurement]
)

where a significant error can be seen spiking on C (can be seen in @paper:realplan) for 2.4 GHz, where it is the furthest from source and most obstacles between, while similar thing also happens in FEKO. The same thing doesn't occur in 5 GHz comparison, where the result is fairly alright.


= Conclusion

Electromagnetic wave propagation modelling by select interactions/phenomenons may still have long way to provide more acurate and reliable result, if accurate numerical is necessary. After all, in contrast to full wave modelling, ray tracing as asymptotic approach disregard numerous aspects and properties of the field. Nevertheless, with some discrepancies in closed simple floorplan, where both 2.4 GHz and 5 GHz suffers a 13% error rate with peculiar error spike in LOS. Comparison in real world floorplan gives a more rational readings where 2.4 GHz has 10.3% error rate and 5 GHz gives 9.2%, which is comply to the properties of asymptotic approach that prevers higher frequencies. The algorithm suffers a significant error at particular position when compared to measurement in 2.4 GHz, up to 40%. But the same thing doesnt happen for 5 GHz, where the significant error is maxed at 10%. Overall, the algorithm is sufficient for quick-and-dirty coverage checking for a given floorplan.